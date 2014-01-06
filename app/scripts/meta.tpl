(function() {
  'use strict';
  define([], function() {
    var meta = {}
    meta.appname = '<%= appname %>';
    meta.version = '<%= version %>';
    meta.debug = <%= debug %>;
    return meta;
  });
}).call(this);
