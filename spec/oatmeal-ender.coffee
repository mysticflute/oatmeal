describe 'oatmeal', ->
  oatmeal = require 'oatmeal'

  afterEach -> oatmeal.munchMunch()

  describe 'integrating with ender', ->
    it 'routes $.cookie to oatmeal.cookie', ->
      $.cookie 'test', 1
      expect($.cookie 'test').toEqual 1

    it 'routes $.deleteCookie to oatmeal.munch', ->
      $.cookie 'test', 1
      $.cookie 'test2', 2
      expect($.cookie 'test').not.toBeNull
      $.deleteCookie 'test'
      expect($.cookie 'test').toBeNull

    it 'routes $.deleteCookies to oatmeal.munchMunch', ->
      $.cookie 'test', 1
      $.cookie 'test2', 2
      $.deleteCookies()
      expect($.cookie 'test').toBeNull
      expect($.cookie 'test2').toBeNull

    it 'routes $.serializeCookie to oatmeal.bake', ->
      expect($.serializeCookie 'test', 2, { secure: true }).toEqual 'test=2; path=/; secure'

    it 'routes $.useCookieSource to oatmeal.source', ->
      $.useCookieSource 'test=1'
      expect($.cookie 'test').toEqual 1

    it 'routes $.refreshCookies to oatmeal.refillJar', ->
      $.cookie 'test', 1
      expect($.cookie 'test').toEqual 1
      $.useCookieSource 'test=2'
      expect($.cookie 'test').toEqual 1
      $.refreshCookies()
      expect($.cookie 'test').toEqual 2