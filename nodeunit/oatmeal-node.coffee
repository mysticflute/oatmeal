oatmeal = require '../dist/oatmeal'

exports.setUp = (callback) ->
  oatmeal.source null
  callback()

exports.testSourceAndCookie = (test) ->
  test.expect 2
  oatmeal.source 'test1=1; test2=%22test2%22'
  test.equal oatmeal.cookie('test1'), 1
  test.equal oatmeal.cookie('test2'), 'test2'
  test.done()

exports.testBake = (test) ->
  test.expect 1
  string = oatmeal.bake 'test', 2
  test.equal string, 'test=2; path=/'
  test.done()

exports.testCookieWithoutSource = (test) ->
  oatmeal.cookie 'honalulu' # no errors
  test.done()