describe 'oatmeal', ->
  oatmeal = window.oatmeal

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
      # 's2' should be found, ignore space before it in 's1=test; s2=2'
      expect(oatmeal.cookie 's2').toEqual 2


  describe 'when baking a cookie', ->

    it 'can be secure', ->
      result = oatmeal.bake 'test', 1, {  secure: true }
      expect(result).toMatch 'secure'

    it 'can not be secure', ->
      result = oatmeal.bake 'test', 1, {  secure: false }
      expect(result).not.toMatch 'secure'

    it 'uses the default path', ->
      result = oatmeal.bake 'test', 1
      expect(result).toMatch 'path=/'

    it 'uses a specified path', ->
      result = oatmeal.bake 'test', 1, { path: 'abc' }
      expect(result).toMatch 'path=abc'

    it 'uses the expiration date', ->
      date = new Date()
      result = oatmeal.bake 'test', 1, { expires: date }
      expect(result).toMatch "expires=#{date.toUTCString()}"

    it 'can expire in seconds', ->
      date = new Date();
      result = oatmeal.bake 'test', 1, { seconds: 30 }
      expect(result).toMatch "expires"

    it 'can expire in days', ->
      date = new Date();
      result = oatmeal.bake 'test', 1, { days: 30 }
      expect(result).toMatch "expires"

    it 'can expire in months', ->
      date = new Date();
      result = oatmeal.bake 'test', 1, { months: 30 }
      expect(result).toMatch "expires"

    it 'can expire in seconds', ->
      date = new Date();
      result = oatmeal.bake 'test', 1, { years: 30 }
      expect(result).toMatch "expires"

    # expires + days
    it 'can expire in at a date plus time', ->
      date = new Date();
      result = oatmeal.bake 'test', 1, { expires: date, seconds: 10 }
      date.setTime date.getTime() + (10 * 1000)
      expect(result).toMatch "expires=#{date.toUTCString()}"

    # days + seconds

    # no expires
    it 'can never expire', ->
      result = oatmeal.bake 'test', 1
      expect(result).not.toMatch 'expires'

  # use source

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
