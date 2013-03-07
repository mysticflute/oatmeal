###!
 * oatmeal - copyright (c) Nathan McWilliams 2013
 * https://github.com/endium/oatmeal
 * MIT license
###

'use strict'

cookies = null

### takes a raw cookie string and returns a map of key-value pairs ###
map = (string) ->
  # will store our key value pairs
  pairs = {}

  # split the string into invidual items
  cookiesList = string.split /;\s/g

  for cookie in cookiesList
    pair = cookie.split '='
    pairs[pair[0]] = decode pair[1]

  return pairs

encode = (value) -> encodeURIComponent JSON.stringify(value)

decode = (value) -> JSON.parse decodeURIComponent(value)

cookieJar = -> cookies ?= map document.cookie

cookie = (name, value, options) -> if value? then set(name, value, options) else get(name)

get = (name) -> cookieJar()[name]

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

  date.setTime(date.getTime() + length)

  path = serialize 'path', options.path
  domain = serialize 'domain', options.domain
  secure = serialize 'secure', options.secure
  expires = serialize 'expires', if options.expires? or length is not 0 then date.toUTCString() else null

  console.log "\ncookie set to: #{name}=#{encode value}#{expires}#{path}#{domain}#{secure}"
  document.cookie = "#{name}=#{encode value}#{expires}#{path}#{domain}#{secure}"

serialize = (name, value) ->
  if not value? then return ''
  if value is yes or value is no then "; #{name}" else "; #{name}=#{value}"

refresh = -> cookies = null

emptyJar = ->
  {} # TODO

# public API
oatmeal = {
  ###
  options:
    expires
    seconds
    minutes
    hours
    days
    months
    years
    domain
    secure
    path

  ###
  cookie: cookie
  refresh: refresh
  emptyJar: emptyJar

  # empty cookie jar

}

if module? and module.exports? then module.exports = oatmeal else window.oatmeal = oatmeal
