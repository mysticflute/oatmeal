
/*
integration with Ender (ender.jit.su)
*/


(function() {
  'use strict';
  var oatmeal;

  oatmeal = require('oatmeal');

  $.ender({
    cookie: oatmeal.cookie,
    deleteCookie: oatmeal.munch,
    deleteCookies: oatmeal.munchMunch,
    serializeCookie: oatmeal.bake,
    useCookieSource: oatmeal.source
  });

}).call(this);
