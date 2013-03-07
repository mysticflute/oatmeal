describe 'oatmeal', ->
  oatmeal = window.oatmeal

  describe 'when eating a cookie', ->
    beforeEach -> oatmeal.refresh()

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

  # trim

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

  # empty cookie jar

  describe 'a refresh', ->
    it 'is required once a cookie has been read', ->
      # first a set
      oatmeal.cookie 'test', 1

      # then a read... now the cookies are parsed
      oatmeal.cookie 'test'

      # another set
      oatmeal.cookie 'test2', 2

      # shouldn't find the cookie because we've already read them
      expect(oatmeal.cookie 'test2').not.toBeDefined()

      # but if we refresh...
      oatmeal.refresh()

      # it should find it
      expect(oatmeal.cookie 'test2').toBeDefined()
