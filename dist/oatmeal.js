
/*!
 * oatmeal - copyright (c) Nathan McWilliams 2013
 * https://github.com/endium/oatmeal
 * MIT license
*/


(function() {
  'use strict';
  var cookie, cookieJar, cookies, decode, emptyJar, encode, get, map, oatmeal, refresh, serialize, set;

  cookies = null;

  /* takes a raw cookie string and returns a map of key-value pairs
  */


  map = function(string) {
    var cookie, cookiesList, pair, pairs, _i, _len;
    pairs = {};
    cookiesList = string.split(/;\s/g);
    for (_i = 0, _len = cookiesList.length; _i < _len; _i++) {
      cookie = cookiesList[_i];
      pair = cookie.split('=');
      pairs[pair[0]] = decode(pair[1]);
    }
    return pairs;
  };

  encode = function(value) {
    return encodeURIComponent(JSON.stringify(value));
  };

  decode = function(value) {
    return JSON.parse(decodeURIComponent(value));
  };

  cookieJar = function() {
    return cookies != null ? cookies : cookies = map(document.cookie);
  };

  cookie = function(name, value, options) {
    if (value != null) {
      return set(name, value, options);
    } else {
      return get(name);
    }
  };

  get = function(name) {
    return cookieJar()[name];
  };

  set = function(name, value, options) {
    var date, domain, expires, length, path, secure;
    if (options == null) {
      options = {};
    }
    date = options.expires || new Date();
    length = 0;
    if (options.seconds != null) {
      length += 1000 * options.seconds;
    }
    if (options.minutes != null) {
      length += 1000 * 60 * options.minutes;
    }
    if (options.hours != null) {
      length += 1000 * 60 * 60 * options.hours;
    }
    if (options.days != null) {
      length += 1000 * 60 * 60 * 24 * options.days;
    }
    if (options.months != null) {
      length += 1000 * 60 * 60 * 24 * 30 * options.months;
    }
    if (options.years != null) {
      length += 1000 * 60 * 60 * 24 * 365 * options.years;
    }
    date.setTime(date.getTime() + length);
    path = serialize('path', options.path);
    domain = serialize('domain', options.domain);
    secure = serialize('secure', options.secure);
    expires = serialize('expires', (options.expires != null) || length === !0 ? date.toUTCString() : null);
    console.log("\ncookie set to: " + name + "=" + (encode(value)) + expires + path + domain + secure);
    return document.cookie = "" + name + "=" + (encode(value)) + expires + path + domain + secure;
  };

  serialize = function(name, value) {
    if (value == null) {
      return '';
    }
    if (value === true || value === false) {
      return "; " + name;
    } else {
      return "; " + name + "=" + value;
    }
  };

  refresh = function() {
    return cookies = null;
  };

  emptyJar = function() {
    return {};
  };

  oatmeal = {
    /*
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
    */

    cookie: cookie,
    refresh: refresh,
    emptyJar: emptyJar
  };

  if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
    module.exports = oatmeal;
  } else {
    window.oatmeal = oatmeal;
  }

}).call(this);
