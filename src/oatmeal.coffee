###!
 * oatmeal - copyright (c) Nathan McWilliams 2013
 * https://github.com/endium/oatmeal
 * MIT license
###

'use strict'

cookieJar = null
source = null

###
Gets the specified source containing the cookie string, or document.cookie if not set.
@returns a string containing the cookies to parse or null if not available.
###
getSource = -> source or document.cookie or null

###
Specifies the specific string to parse for cookies.
@param {String} src The properly formatted string containing the cookies.
###
setSource = (src) -> source = src

###
Encodes a cookie value and converts it to a JSON string.
@param {Object|Number|Boolean|String} value The value to encode.
###
encode = (value) -> encodeURIComponent JSON.stringify(value)

###
Decodes a cookie value. If the original value was a boolean, string or number
then that's what will be returned. Otherwise if it was an object then the object
will be returned.

@param {String} the JSON/URI encoded value
###
decode = (value) -> JSON.parse decodeURIComponent(value)

###
Gets a cookie value by name.

@param {String} name The name of the cookie to retrieve.
###
get = (name) -> (cookieJar ?= fillJar getSource())[name]

###
Saves a cookie to document.cookie.

The value will always be encoded and JSON-stringified.

@param {String} name The name of the cookie to save.
@param {String|Boolean|Number|Object} value The value of the cookie. This can be a full blown object
                                            to be JSONified, or a simple scalar value as well.
@param {Object} [options] Optional configuration options. See the #cookie method for detailed list.
###
set = (name, value, options) -> document.cookie = bake(name, value, options); refillJar()

###
Takes a raw cookie string and returns a map of key-value pairs.

@param {String} string The string to parse, e.g., from getSource().
@returns an object with key/value pairs from the parsed input.
###
fillJar = (string) ->
  pairs = {}

  if not string then return pairs

  for cookie in string.split /;\s+/g
    pair = cookie.split '='
    pairs[pair[0]] = decode pair[1]

  pairs

###
Refreshes the cookies cache. Normally you won't need to call this externally.
However, you might need to if you say, respecify the source.
###
refillJar = -> cookieJar = fillJar(getSource()) unless getSource() is null

###
Constructs a properly formatted cookie string using the given information.
Use this method instead of #cookie(name, value, options) if you want the raw
cookie string instead of setting document.cookie (for example, to use on the nodejs server).

The value will always be encoded and JSON-stringified.

@param {String} name The name of the cookie to save
@param {String|Boolean|Number|Object} value The value of the cookie. This can be a full blown object
                                            to be JSONified, or a simple scalar value as well.
@param {Object} [options] Optional configuration options. See the #cookie method for detailed list.

@returns The properly formatted cookie string, e.g, 'name=value; path=/'
###
bake = (name, value, options = {}) ->
  # to summarize expires calculation...
  # 1. if 'expires' or any of the time lengths are not specified then expires will not be output
  # 2. if 'expires' is specified, any time lengths will be added on to that date's time
  # 3. if 'expires' is not specified, any time lengths will be added to the current time
  # 4. any of the time length options can be provided; they are cumulative

  date = options.expires or new Date()

  length = 0
  length += 1000 * options.seconds if options.seconds?
  length += 1000 * 60 * options.minutes if options.minutes?
  length += 1000 * 60 * 60 * options.hours if options.hours?
  length += 1000 * 60 * 60 * 24 * options.days if options.days?
  length += 1000 * 60 * 60 * 24 * 30 * options.months if options.months?
  length += 1000 * 60 * 60 * 24 * 365 * options.years if options.years?
  date.setTime(date.getTime() + length)


  path = serialize 'path', options.path or '/'
  domain = serialize 'domain', options.domain
  secure = serialize 'secure', options.secure
  expires = serialize 'expires', if options.expires? or length isnt 0 then date.toUTCString() else null

  "#{name}=#{encode value}#{expires}#{path}#{domain}#{secure}"

###
Helper method to construct the cookie string.

@param {String} name Name of the item.
@param {Boolean|String|Number} value The value of the item.

@returns if value is not present, an empty string. If value is boolean true, then
just a string containing the name. Otherwise a string in the format of 'name=value'.
###
serialize = (name, value) ->
  if not value? or value is no then return ''
  if value is yes then "; #{name}" else "; #{name}=#{value}"

###
Deletes a cookie.

@param {String} name Name of the cookie to remove.
###
munch = (name) -> set(name, '(del)', { days: -1 })

###
Deletes all cookies
###
munchMunch = ->
  refillJar()
  munch cookie for own cookie of cookieJar
  cookieJar = null

###
Main entry point for reading and writing cookies.

if the 'name' parameter alone is specified then the cookie's value will be returned.
If both the 'name' and 'value' parameters are specified, this will set the cookie's value.

The cookie value will always be encoded and JSONified. This means you can pass in full JSON
compatible objects as the cookie value. When the cookie is read later, it will be decoded from JSON
back into the object.

You can also pass in several options, as described below.

Note that the time lengths are cumulative. More than one can be specified, and they will be added on
to either options.expires (if specified) or the current time.

@param {String} name The name of the cookie to read or write.
@param {String|Boolean|Number|Object} value The value of the cookie to write. This value will be JSONified.
@param {Object} [options] Object containing futher options.
@param {String} [options.domain] Specify the domain of the cookie.
@param {Boolean} [options.secure] Specify that the cookie is secure.
@param {Date} [options.expires] Specify a Date object for when the cookie should expire.
@param {Number} [options.seconds] Specify additional seconds to add to optional.expires or the current time.
@param {Number} [options.minutes] Specify additional minutes to add to optional.expires or the current time.
@param {Number} [options.hours] Specify additional hours to add to optional.expires or the current time.
@param {Number} [options.days] Specify additional days to add to optional.expires or the current time.
@param {Number} [options.months] Specify additional ~months to add to optional.expires or the current time.
@param {Number} [options.years] Specify additional ~years to add to optional.expires or the current time.
###
cookie = (name, value, options) -> if value? then set(name, value, options) else get(name)

# client/browser API
oatmeal =
  # get cookie string for serialization
  bake: bake
  # delete specified cookie
  munch: munch
  # get or set cookie
  cookie: cookie
  # reread cookies from source
  refillJar: refillJar
  # specify the cookie source (default document.cookie)
  source: setSource
  # delete all cookies
  munchMunch: munchMunch

# node API
oatmealNode =
  # get cookie string for serialization
  bake: bake
  # specify the cookie string to parse
  source: source

# export to the world
if process?.pid
  module.exports = oatmealNode
else
  if module? and module.exports? then module.exports = oatmeal else window.oatmeal = oatmeal

