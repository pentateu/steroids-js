class EntityProxy

	constructor: (@entity={}) ->
		console.log "EntityProxy created ->name: #{entity.name}"

	notify: (notification={}) ->
		console.log "entity proxy received notification " + JSON.stringify(notification)

	add: (instance, callbacks={}) ->
		if instance?
			steroids.nativeBridge.nativeCall
      			method: "steroidsData"
      			parameters:
      				method: "add"
      				entity: entity
      				instance: instance
      			successCallbacks: [callbacks.onSuccess]
      			failureCallbacks: [callbacks.onFailure]


    getAll: (instance, callbacks={}) ->
		if instance?
			steroids.nativeBridge.nativeCall
      			method: "steroidsData"
      			parameters:
      				method: "getAll"
      				entity: entity
      			successCallbacks: [callbacks.onSuccess]
      			failureCallbacks: [callbacks.onFailure]