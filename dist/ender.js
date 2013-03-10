(function() {
  var oatmeal;

  oatmeal = require('oatmeal');

  $.ender({
    cookie: oatmeal.cookie,
    deleteCookie: oatmeal.munch,
    deleteCookies: oatmeal.munchMunch,
    serializeCookie: oatmeal.bake,
    refreshCookies: oatmeal.refillJar,
    useCookieSource: oatmeal.source
  });

}).call(this);
