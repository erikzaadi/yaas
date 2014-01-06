'use strict'
define([
  'app'
  'meta'
  ], (app, meta) ->
    return if not document.URL.match /__nobackend__/
    console.warn "Stub Mode!!1, no backend active"
    angular.module(meta.appname)
      .config(
        [
          "$provide", 
          ($provide) ->
            $provide.decorator '$httpBackend', angular.mock.e2e.$httpBackendDecorator
        ]
      )
      .run([
        '$httpBackend'
        ($httpBackend) ->
           tests = [
                 test: 123
                 id: 123
               ,
                 test: 321
                 id: 321
           ]

           $httpBackend.when('GET', '/api/v1/tests').respond(tests)
           $httpBackend.when('GET', '/api/v1/tests/123').respond(tests[0])
           $httpBackend.when('GET', '/api/v1/tests/321').respond(tests[1])
           
      ])
  )
