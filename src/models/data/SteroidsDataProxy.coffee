class SteroidsDataProxy
	constructor: (@options={}) ->
		console.log "SteroidsData created"

	@entityStore = {}

    # called when a entity is defined in the common
	@entityDefined: (delegateCallback) ->
		myCallBack = (entity={}) ->
    		console.log 'entity defined ... name: #{entity.name}'

    		# create a proxy for the entity
    		entityProxy = new EntityProxy(entity)

    		SteroidsDataProxy.entityStore[entity.name] = entityProxy

    		# send the proxy to the delegate callback
    		delegateCallback(entityProxy)

    # called when an notification happens for an entity
	@entityNotification: (entity={}, notification={}) ->
    	console.log 'entity updated ... name: #{entity.name} - notification type: #{notification.type}'

    	entityProxy = SteroidsDataProxy.entityStore[entity.name]

    	if entityProxy?
    		entityProxy.notify(notification);

    # define a new Entity
  	define: (entity={}, callbacks={}) =>
  		steroids.nativeBridge.nativeCall
      		method: "steroidsData"
      		parameters:
      			method: "define"
      			entity: entity
      		successCallbacks: [SteroidsDataProxy.entityDefined(callbacks.onSuccess)]
      		recurringCallbacks: [SteroidsDataProxy.entityNotification]
      		failureCallbacks: [callbacks.onFailure]