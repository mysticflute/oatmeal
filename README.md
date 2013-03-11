oatmeal
=======

A lightweight cookie manager for both the browser and nodejs.

Why another cookie manager?
---------------------------

light as a feather

**1.66kb minified, 450 bytes gzipped**

flexible expires

```js
oatmeal.cookie("raisin",      "yumyum", { seconds: 50 })
oatmeal.cookie("chewy",       "yumyum", { minutes: 10 })
oatmeal.cookie("thick",       "yumyum", { hours: 12 })
oatmeal.cookie("soft",        "yumyum", { days: 15 })
oatmeal.cookie("Specialty's", "yum!",   { months: 3 })
oatmeal.cookie("thin",        "meh",    { years: 1 })
oatmeal.cookie("crunchy",     "meh!",   { expires: new Date() })
```

flexible might be an understatement

```js
oatmeal.cookie("raisin", "yummy", { months: 3, days: 10 })
oatmeal.cookie("raisin", "yummy", { months: 3, days: 10, seconds: 10 })
oatmeal.cookie("raisin", "yummy", { expires: myDate, days: 10 })
```

works with your objects, not against

```js
var penelope = {
    age: 26,
    height: "6'1",
    beautiful: "yes"
}
oatmeal.cookie("person", penelope)
```

Usage
-----

### options

Some of the methods take an optional `options` configuration object

- **expires** expiration date of the cookie (Date object)
- **seconds** expiration in seconds. Combinable with other time options.
- **minutes** expiration in minutes. Combinable with other options.
- **hours** expiration in hours. Combinable with other options.
- **days** expiration in days. Combinable with other options.
- **months** expiration in months (1 = 30 days). Combinable with other options.
- **years** expiration in years (1 = 365 days). Combinable with other options.
- **path** path of the cookie, default is `/`.
- **domain** domain of the cookie.
- **secure** specify true to add `secure` to the cookie string.

A couple of notes. Without `expires`, all of the timing is relative to the current time. With `expires`, the other timing options are added to the date specified.

Timing options can be combined together, e.g., you can specify `months: 1, days: 3` to get an expiration date of one month and three days from now.

### ~ Cookies in yur browser ~

#### oatmeal.cookie(name, value [, options])

Sets a cookie named `name` to `value`. Note that `value` can be a string, boolean, number or object. The value will always be encoded and JSONized.

#### oatmeal.cookie(name)

Gets the value for a cookie called `name`.

#### oatmeal.bake(name, value [, options])

Similar to `oatmeal.cookie(name, value)` except that it avoids setting the actual cookie and returns the properly formatted cookie string instead, e.g., `name=key; path=/; secure`. This is mainly useful on the node side.

#### oatmeal.munch(name)

Deletes the cookie with the specified name.

#### oatmeal.munchMunch

Deletes all cookies.

#### oatmeal.refillJar

Forces a refresh of the known cookies. Normally you won't need to call this externally. An instance where you might need to is if you respecify the source. The previously parsed cookies would be cached and unless you add a new one it won't get updated. You can force that update instead by calling this method.

#### oatmeal.source(string)

Specifies a string to parse for cookies. This is mainly useful on the node side.

### ~ Cookies in yur nodez ~

You can use oatmeal in nodejs as well, albeit in a limited fashion.

#### oatmeal.bake(name, value [, options])

Generates a properly formatted cookie string for the given parameters. It's up to you to actually set the response header, i.e., `Set-Cookie`.

#### oatmeal.source(string)

Specifies the string to parse for cookies. You can grab this from the request headers.

Ender
-----

This library works with [Ender](http://ender.jit.su)!

    ender build oatmeal

When used with ender, the method names are changed up a bit because we're on a global namespace object ($).

- `$.cookie` = `oatmeal.cookie`
- `$.deleteCookie` = `oatmeal.munch`
- `$.deleteCookies` = `oatmeal.munchMunch`
- `$.refreshCookies` = `oatmeal.refillJar`
- `$.serializeCookie` = `oatmeal.bake`
- `$.useCookieSource` = `oatmeal.source`

Othewise, everything else should work the same. You can also `require` the oatmeal library.

```js
var oatmeal = require('oatmeal')
```

Support
-------

This library depends on `JSON.parse` and `JSON.stringify`. This is natively supported in browsers Internet Explorer 8+, Firefox 3.1+, Safari 4+, Chrome 3+. If you are unfortunate enough to have to care about older browsers, it's up to you to polyfill the behavior.