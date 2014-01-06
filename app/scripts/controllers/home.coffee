'use strict'

class HomeCtrl
  @$inject: ['$scope'] 
  constructor: (@$scope) ->
    @$scope.awesomeThings = [
      'Awesome'
      'Ness'
      'and'
      'such'
    ]

define ['meta', 'controllers/base'], (meta) ->
  angular
    .module("#{meta.appname}.controllers")
    .controller 'HomeCtrl', HomeCtrl
  return HomeCtrl
