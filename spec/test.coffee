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
      oatmeal.munch()
      console.log document.cookie
      console.log 'S' + oatmeal.cookie ' s1'


  describe 'when baking a cookie', ->

    # secure

    # no secure

    # path

    # no path

    # expires date

    # expire seconds

    # expires days

    # expires months

    # expires years

    # expires expires + days

    # no expires

  describe 'when a cookie is eaten', ->

    # empty cookie jar

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
