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
  refreshCookies: oatmeal.refillJar
  useCookieSource: oatmeal.source