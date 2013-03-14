###
integration with Ender (ender.jit.su)
###

'use strict'

oatmeal = require('oatmeal')

$.ender
  cookie: oatmeal.cookie
  deleteCookie: oatmeal.munch
  deleteCookies: oatmeal.munchMunch
  serializeCookie: oatmeal.bake
  useCookieSource: oatmeal.source