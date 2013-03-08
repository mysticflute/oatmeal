
/*!
 * oatmeal - copyright (c) Nathan McWilliams 2013
 * https://github.com/endium/oatmeal
 * MIT license
*/


(function() {
  'use strict';
  var bake, cookie, cookieJar, decode, encode, fillJar, get, getSource, munch, munchMunch, oatmeal, oatmealNode, refillJar, serialize, set, setSource, source,
    __hasProp = {}.hasOwnProperty;

  cookieJar = null;

  source = null;

  /*
  Gets the specified source containing the cookie string, or document.cookie if not set.
  @returns a string containing the cookies to parse or null if not available.
  */


  getSource = function() {
    return source || document.cookie || null;
  };

  /*
  Specifies the specific string to parse for cookies.
  @param {String} src The properly formatted string containing the cookies.
  */


  setSource = function(src) {
    return source = src;
  };

  /*
  Encodes a cookie value and converts it to a JSON string.
  @param {Object|Number|Boolean|String} value The value to encode.
  */


  encode = function(value) {
    return encodeURIComponent(JSON.stringify(value));
  };

  /*
  Decodes a cookie value. If the original value was a boolean, string or number
  then that's what will be returned. Otherwise if it was an object then the object
  will be returned.
  
  @param {String} the JSON/URI encoded value
  */


  decode = function(value) {
    return JSON.parse(decodeURIComponent(value));
  };

  /*
  Gets a cookie value by name.
  
  @param {String} name The name of the cookie to retrieve.
  */


  get = function(name) {
    return (cookieJar != null ? cookieJar : cookieJar = fillJar(getSource()))[name];
  };

  /*
  Saves a cookie to document.cookie.
  
  The value will always be encoded and JSON-stringified.
  
  @param {String} name The name of the cookie to save.
  @param {String|Boolean|Number|Object} value The value of the cookie. This can be a full blown object
                                              to be JSONified, or a simple scalar value as well.
  @param {Object} [options] Optional configuration options. See the #cookie method for detailed list.
  */


  set = function(name, value, options) {
    return document.cookie = bake(name, value, options);
  };

  /*
  Takes a raw cookie string and returns a map of key-value pairs.
  
  @param {String} string The string to parse, e.g., from getSource().
  @returns an object with key/value pairs from the parsed input.
  */


  fillJar = function(string) {
    var cookie, pair, pairs, _i, _len, _ref;
    pairs = {};
    _ref = string.split(/;\s+/g);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cookie = _ref[_i];
      pair = cookie.split('=');
      pairs[pair[0]] = decode(pair[1]);
    }
    return pairs;
  };

  /*
  Refresh the cookies cache. This is useful in cases where you need to set a cookie and read
  the value back later within the same page load. Otherwise, it will only find cookies from
  the point in time which the cookie string was originally read.
  */


  refillJar = function() {
    if (getSource() !== null) {
      return cookieJar = fillJar(getSource());
    }
  };

  /*
  Constructs a properly formatted cookie string using the given information.
  Use this method instead of #cookie(name, value, options) if you want the raw
  cookie string instead of setting document.cookie (for example, to use on the nodejs server).
  
  The value will always be encoded and JSON-stringified.
  
  @param {String} name The name of the cookie to save
  @param {String|Boolean|Number|Object} value The value of the cookie. This can be a full blown object
                                              to be JSONified, or a simple scalar value as well.
  @param {Object} [options] Optional configuration options. See the #cookie method for detailed list.
  
  @returns The properly formatted cookie string, e.g, 'name=value; path=/'
  */


  bake = function(name, value, options) {
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
    path = serialize('path', options.path || '/');
    domain = serialize('domain', options.domain);
    secure = serialize('secure', options.secure);
    expires = serialize('expires', (options.expires != null) || length !== 0 ? date.toUTCString() : null);
    return "" + name + "=" + (encode(value)) + expires + path + domain + secure;
  };

  /*
  Helper method to construct the cookie string.
  
  @param {String} name Name of the item.
  @param {Boolean|String|Number} value The value of the item.
  
  @returns if value is not present, an empty string. If value is boolean true, then
  just a string containing the name. Otherwise a string in the format of 'name=value'.
  */


  serialize = function(name, value) {
    if ((value == null) || value === false) {
      return '';
    }
    if (value === true) {
      return "; " + name;
    } else {
      return "; " + name + "=" + value;
    }
  };

  /*
  Deletes a cookie.
  
  @param {String} name Name of the cookie to remove.
  */


  munch = function(name) {
    return set(name, '(del)', {
      days: -1
    });
  };

  /*
  Deletes all cookies
  */


  munchMunch = function() {
    var cookie;
    refillJar();
    for (cookie in cookieJar) {
      if (!__hasProp.call(cookieJar, cookie)) continue;
      munch(cookie);
    }
    return cookieJar = null;
  };

  /*
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
  */


  cookie = function(name, value, options) {
    if (value != null) {
      return set(name, value, options);
    } else {
      return get(name);
    }
  };

  oatmeal = {
    bake: bake,
    munch: munch,
    cookie: cookie,
    refillJar: refillJar,
    source: setSource,
    munchMunch: munchMunch
  };

  oatmealNode = {
    bake: bake,
    source: source
  };

  if (typeof process !== "undefined" && process !== null ? process.pid : void 0) {
    module.exports = oatmealNode;
  } else {
    if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
      module.exports = oatmeal;
    } else {
      window.oatmeal = oatmeal;
    }
  }

}).call(this);
