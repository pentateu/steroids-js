class WebBridge extends Bridge

  constructor: ()->
    window.AG_SCREEN_ID = 0
    window.AG_LAYER_ID = 0
    window.AG_VIEW_ID = 0

    refresh =
      id: null
      timestamp: (new Date()).getTime()

    if window.EventSource?
      source = new EventSource("http://localhost:4567/refresh_client_events?#{refresh.timestamp}")
      source.addEventListener "refresh", (e)->
        window.location.reload() if e.data == "true"
      , false

      source.addEventListener "open", (e)->
        console.log "Monitoring updates from steroids npm."
      , false

      source.addEventListener "error", (e)->
        if e.readyState == EventSource.CLOSED
          console.log "No longer monitoring updates from steroids npm."
    else
      pollForRefresh = ()->
        xhr = new XMLHttpRequest()
        xhr.onload = ()->
          window.location.reload() if @readyState is 4 and @status is 200 and @responseText is "true"

        xhr.open("GET", "http://localhost:4567/refresh_client?#{refresh.timestamp}")
        xhr.send()

      refresh.id = setInterval pollForRefresh, 1000

    return @

  @isUsable: ()->
    return typeof window.chrome != 'undefined'

  sendMessageToNative:(messageString)->
    message = JSON.parse(messageString)

    console.log "WebBridge: #{JSON.stringify(message)}"

    ripplefyURL = (url)->
      if window.top.location.search.indexOf("enableripple")
        url += if url.split('?').length > 1
          "&enableripple=#{window.top.steroids.view.params.enableripple}"
        else
          "?enableripple=#{window.top.steroids.view.params.enableripple}"
      return url


    failed = false

    successOptions = {}
    failureOptions = {}

    switch message.method
      when "ping"
        successOptions.message = "PONG"
      when "openLayer"

        window.top.open ripplefyURL(message.parameters.url), "_blank"
      when "openURL"
        window.top.open ripplefyURL(message.parameters.url), "_blank"
      when "openModal"
        modal = document.createElement "iframe"
        modal.src = ripplefyURL(message.parameters.url)
        modal.width = "100%"
        modal.height = "100%"
        modal.style.position = "absolute"
        modal.style.top = "10px"
        modal.style.left = "10px"
        modal.className = "steroidsModal"

        document.body.appendChild modal

        closeButton = document.createElement "button"
        closeButton.style.position = "absolute"
        closeButton.style.top = "0px"
        closeButton.style.left = "0px"
        closeButton.textContent = "CLOSE MODAL"

        closeButton.onclick = () =>
          modal.parentNode.removeChild(modal)
          closeButton.parentNode.removeChild(closeButton)

        document.body.appendChild closeButton

      else
        console.log "WebBridge: unsupported API method: #{message.method}"
        failed = true


    if failed
      #@callbacks[message.callbacks.failure].call(@)
    else
      @callbacks[message.callbacks.success].call(@, successOptions)