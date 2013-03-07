oatmeal
=======

A lightweight, opinionated cookie manager

target = < 8 KB on disk (6,482 bytes) minified

relies on:
String.trim() (supported since ff3.5, ie9+, chrome, safari5)
JSON.stringify and JSON.parse (Internet Explorer 8+, Firefox 3.1+, Safari 4+, Chrome 3+)



- everything is JSON ified (no options for raw)
- no option for httpOnly or maxAge
