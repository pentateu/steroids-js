class EntityProxy

	constructor: (@entity={}) ->
		@events = {}
		console.log "EntityProxy created -> name: #{@entity.name}"

	on: (eventName, handler) ->
		console.log "EntityProxy on -> eventName: #{eventName}"

		handlers =  if @events[eventName]?
			@events[eventName]
		else
			[]

		handlers.push handler

		@events[eventName] = handlers

	notify: (event={}) ->
		console.log "entity proxy received event: #{JSON.stringify(event)}"
		handlers = @events[event.type]
		if handlers?
			for fn in handlers
				fn(event)

	getAll: (instance, callbacks={}) ->
		if instance?
			steroids.nativeBridge.nativeCall
      			method: "executeOnCommonRuntime"
      			parameters:
      				module: "steroidsData"
      				func: "getAll"
      			successCallbacks: [callbacks.onSuccess]
      			failureCallbacks: [callbacks.onFailure]

	add: (instance, callbacks={}) ->
		if instance?
			steroids.nativeBridge.nativeCall
      			method: "executeOnCommonRuntime"
      			parameters:
      				module: "steroidsData"
      				func: "add"
      				entityName: @entity.name
      				instance: instance
      			successCallbacks: [callbacks.onSuccess]
      			failureCallbacks: [callbacks.onFailure]