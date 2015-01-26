{forwardMethod} = Trix.Helpers

class Trix.Operation
  isPerforming: ->
    @performing is true

  hasPerformed: ->
    @performed is true

  hasSucceeded: ->
    @performed and @succeeded

  hasFailed: ->
    @performed and not @succeeded

  getPromise: ->
    @promise ?= new Promise (resolve, reject) =>
      @performing = true
      @perform (@succeeded, result) =>
        delete @performing
        @performed = true

        if @succeeded
          resolve(result)
        else
          reject(result)

  perform: (callback) ->
    callback(false)

  release: ->
    @promise?.cancel()
    delete @promise
    delete @performing
    delete @performed
    delete @succeeded

  forwardMethod "then", onConstructor: this, toMethod: "getPromise"
  forwardMethod "catch", onConstructor: this, toMethod: "getPromise"
