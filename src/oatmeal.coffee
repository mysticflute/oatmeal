###!
 * oatmeal - copyright (c) Nathan McWilliams 2013
 * https://github.com/endium/oatmeal
 * MIT license
###

'use strict'

cookieJar = null

###
Takes a raw cookie string and returns a map of key-value pairs

@param {String} string The string to parse, e.g., from document.cookie

@returns an object with key/value pairs from the parsed input
###
bakeCookies = (string) ->
  pairs = {}

  for cookie in string.split /;\s/g
    pair = cookie.split '='
    console.log 'S'+string
    pairs[pair[0]] = decode pair[1]

  pairs

###
Encodes a cookie value and converts it to a JSON string.

@param {Object|Number|Boolean|String} value The value to encode
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
Gets a cookie value by name/

@param {String} name The name of the cookie to retrieve
###
get = (name) ->
  cookieJar = bakeCookies document.cookie
  cookieJar[name]

###
Sets a cookie value.

The value will always be encoded and JSON-stringified.

@param {String} name The name of the cookie to save
@param {String|Boolean|Number|Object} value The value of the cookie. This can be a full blown object
                                            to be JSONified, or a simple scalar value as well.
@param {Object} [options] Optional configuration options. See the #cookie method for detailed list.
###
set = (name, value, options = {}) ->

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
  console.log "length:#{length}"
  date.setTime(date.getTime() + length)


  path = serialize 'path', options.path or '/'
  domain = serialize 'domain', options.domain
  secure = serialize 'secure', options.secure
  expires = serialize 'expires', if options.expires? or length isnt 0 then date.toUTCString() else null

  console.log "\ncookie set to: #{name}=#{encode value}#{expires}#{path}#{domain}#{secure}"
  document.cookie = "#{name}=#{encode value}#{expires}#{path}#{domain}#{secure}"

###
Helper method to construct the cookie string.

@param {String} name Name of the item.
@param {Boolean|String|Number} value The value of the item.

@returns if value is not present, an empty string. If value is boolean true, then
just a string containing the name. Otherwise a string in the format of 'name=value'.
###
serialize = (name, value) ->
  if not value? then return ''
  if value is yes then "; #{name}" else "; #{name}=#{value}"

###
Refresh the cookies cache, so that subsequent calls to #cookie or #get will reparse
the cookie string first. This is useful in cases where you need to set a cookie and read
the value back later within the same page load. Otherwise, it will only find cookies from
the point in time which the cookie string was originally read.
###
refresh = -> cookieJar = bakeCookies document.cookie

###
Deletes a cookie.

@param {String} name Name of the cookie to remove.
###
munch = (name) ->
  if name?
    set(name, '(del)', { days: -1 })
  else
    munch cookie for own cookie of cookies
    refresh()

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

# public API
oatmeal =
  munch: munch
  cookie: cookie
  refresh: refresh

# export to the world
if module? and module.exports? then module.exports = oatmeal else window.oatmeal = oatmeal