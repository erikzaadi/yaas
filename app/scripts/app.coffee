define [
  'meta'
  'controllers/base'
  'filters/base'
  'directives/base'
  'factories/base'
  'services/base'
  'models/base'
], (meta) ->
  angular.module(meta.appname , [
    "#{meta.appname}.controllers"
    "#{meta.appname}.models"
    "#{meta.appname}.directives"
    "#{meta.appname}.services"
    "#{meta.appname}.filters"
    "#{meta.appname}.factories"
    'ngRoute' 
    'ngResource' 
    'ngCookies' 
  ])
  .config(["$locationProvider", ($location) ->
    $location.html5Mode true
  ])
