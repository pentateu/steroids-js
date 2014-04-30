class SteroidsDataProxy
	constructor: (@options={}) ->
		console.log "SteroidsData created"

	@entityStore = {}

    # called when a entity is defined in the common
	@entityDefined: (entity, delegateCallback) ->
		myCallBack = (result={}) ->
    		console.log "entity defined ... name: #{result.entityName}"

    		# create a proxy for the entity
    		entityProxy = new EntityProxy(entity)

    		SteroidsDataProxy.entityStore[entity.name] = entityProxy

    		# send the proxy to the delegate callback
    		delegateCallback(entityProxy)

    # called when an notification happens for an entity
	@entityNotification: (event={}) ->
    	console.log "entity event ... event: #{JSON.stringify(event)}"

    	entityProxy = SteroidsDataProxy.entityStore[event.entityName]

    	if entityProxy?
    		entityProxy.notify(event);

    # define a new Entity
  	define: (entity={}, callbacks={}) =>
  		steroids.nativeBridge.nativeCall
      		method: "executeOnCommonRuntime"
      		parameters:
      			module: "steroidsData"
      			func: "define"
      			entity: entity
      		successCallbacks: [SteroidsDataProxy.entityDefined(entity, callbacks.onSuccess)]
      		recurringCallbacks: [SteroidsDataProxy.entityNotification]
      		failureCallbacks: [callbacks.onFailure]