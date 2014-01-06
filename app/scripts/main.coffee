require.config
  baseUrl: '/scripts'
  paths:
    'jQuery': '../vendor/jquery/jquery'
    'angular': '../vendor/angular/angular'
    'angular-resource': '../vendor/angular-resource/angular-resource'
    'angular-route': '../vendor/angular-route/angular-route'
    'angular-mocks': '../vendor/angular-mocks/angular-mocks'
    'angular-cookies': '../vendor/angular-cookies/angular-cookies'
  shim:
    'angular': {'exports' : 'angular'}
    'angular-resource': { deps: ['angular']}
    'angular-route': { deps: ['angular']}
    'angular-cookies': { deps: ['angular']}
    'angular-mocks': { deps: ['angular']}
    'app': 
      deps: [
        'angular'
        'angular-resource'
        'angular-cookies'
        'angular-route'
        'angular-mocks'
        'meta'
      ]
    'stubs':
      deps: [
        'app'
      ]
    'jQuery': {'exports': 'jQuery'}

require [
  'jQuery'
  'meta'
  'app'
  'routes'
  'stubs'
], ($, meta) ->
  $ ->
    angular.bootstrap document, [meta.appname]
