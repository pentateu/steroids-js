describe "Splashscreen", ->

  it "should be defined", ->
    steroids.splashscreen.should.be.defined

  it "should have function show", ->
    steroids.splashscreen.show.should.be.a "function"

  it "should have function hide", ->
    steroids.splashscreen.hide.should.be.a "function"

  it "should show splashscreen", (done) ->
    steroids.splashscreen.show {},
      onSuccess: ->
        done()
      onFailure: (error) ->
        done new Error error

  it "should hide splashscreen", (done) ->
      steroids.splashscreen.hide {},
        onSuccess: ->
          done()
        onFailure: (error) ->
          done new Error error