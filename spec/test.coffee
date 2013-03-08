describe 'oatmeal', ->
  oatmeal = window.oatmeal
  date = null
  time = null

  beforeEach ->
    date = new Date()
    time = date.getTime()
    spyOn(Date.prototype, 'getTime').andReturn(time)

  afterEach -> oatmeal.munchMunch()

  describe 'when eating a cookie', ->

    it 'should taste like a string', ->
      oatmeal.cookie 'string', 'value1'
      expect(oatmeal.cookie 'string').toEqual 'value1'

    it 'should taste like an int', ->
      oatmeal.cookie 'int', 1
      expect(oatmeal.cookie 'int').toEqual 1

    it 'should taste like a boolean', ->
      oatmeal.cookie 'bool', true
      expect(oatmeal.cookie 'bool').toBeTrue

    it 'should tase like an object', ->
      test = { first: 'a', second: 'b', third: { inner: 'aha!' }}
      oatmeal.cookie 'obj', test
      expect(oatmeal.cookie('obj').first).toEqual 'a'
      expect(oatmeal.cookie('obj').second).toEqual 'b'
      expect(oatmeal.cookie('obj').third.inner).toEqual 'aha!'

  describe 'when there are many cookies in the cookie jar', ->
    it 'should not contain extra space', ->
      oatmeal.cookie 's1', ' test'
      oatmeal.cookie 's2', 2
      expect(oatmeal.cookie 's2').toEqual 2 # ignore space before s2 in 's1=test; s2=2'

  describe 'when baking a cookie', ->

    it 'can be secure', ->
      expect(oatmeal.bake 'test', 1, { secure: true }).toMatch 'secure'

    it 'can not be secure', ->
      expect(oatmeal.bake 'test', 1, { secure: false }).not.toMatch 'secure'

    it 'uses the default path', ->
      expect(oatmeal.bake 'test', 1).toMatch 'path=/'

    it 'uses a specified path', ->
      expect(oatmeal.bake 'test', 1, { path: 'abc' }).toMatch 'path=abc'

    it 'uses the expiration date', ->
      expect(oatmeal.bake 'test', 1, { expires: date }).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in seconds', ->
      date.setTime time + 1000 * 30
      result = oatmeal.bake 'test', 1, { seconds: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in minutes', ->
      date.setTime time + 1000 * 60 * 30
      result = oatmeal.bake 'test', 1, { minutes: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in hours', ->
      date.setTime time + 1000 * 60 * 60 * 30
      result = oatmeal.bake 'test', 1, { hours: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in days', ->
      date.setTime time + 1000 * 60 * 60 * 24 * 30
      result = oatmeal.bake 'test', 1, { days: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in months', ->
      date.setTime time + 1000 * 60 * 60 * 24 * 30 * 30
      result = oatmeal.bake 'test', 1, { months: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in years', ->
      date.setTime time + 1000 * 60 * 60 * 24 * 365 * 30
      result = oatmeal.bake 'test', 1, { years: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in at a date + time', ->
      date.setTime time + 10 * 1000
      result = oatmeal.bake 'test', 1, { expires: date, seconds: 10 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire at time + time', ->
      date.setTime time + (1000 * 30) + (1000 * 60 * 30)
      result = oatmeal.bake 'test', 1, { seconds: 30, minutes: 30 }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can never expire', ->
      result = oatmeal.bake 'test', 1
      expect(result).not.toMatch 'expires'

  describe 'when sourcing the cookie ingredients', ->
    afterEach -> oatmeal.source null

    it 'honors the source', ->
      oatmeal.source 'test1=1; test2=%22test2%22'
      expect(oatmeal.cookie 'test1').toEqual 1
      expect(oatmeal.cookie 'test2').toEqual 'test2'

  describe 'when a cookie is eaten', ->
    it 'is gone from existence', ->
      oatmeal.cookie 'test', 1
      oatmeal.munch('test')
      expect(document.cookie).toEqual ''

  describe 'restocking the cookie jar', ->
    it 'is required once any cookie has been read', ->
      # first a set
      oatmeal.cookie 'test', 1

      # then a read... now the cookies are parsed
      oatmeal.cookie 'test'

      # another set
      oatmeal.cookie 'test2', 2

      # shouldn't find the cookie because we've already read them
      expect(oatmeal.cookie 'test2').not.toBeDefined()

      # but if we restock...
      oatmeal.refillJar()

      # it should find it
      expect(oatmeal.cookie 'test2').toBeDefined()
