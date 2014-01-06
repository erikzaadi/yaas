'use strict'

define 'controllers/base', ['meta', 'angular'], (meta) ->

  angular.module("#{meta.appname}.controllers", [])
  class BaseModelController
    @$inject: ['$scope', '$resource', '$routeParams'] 
    model: null
    modelInstance: null

    constructor: (@$scope, @$resource, @$routeParams) ->
      console.log "base const"
      @modelInstance = new @model($resource)
#      if not @headers
#        @headers = key for own key of @modelInstance
#
#      @$scope.headers = @headers

  class BaseSingleModelController extends BaseModelController
    constructor: (@$scope, @$resource, @$routeParams) ->
      console.log "base single const"
      #if not @headers
      #  @headers = key for own key of @modelInstance

      #@$scope.headers = @headers

      super(@$scope, @$resource, @$routeParams)
      if @$routeParams.modelId?
        @$scope.model = @modelInstance.get($routeParams.modelId)
      else
        @$scope.model = @modelInstance.empty()

      @$scope.delete = () ->
        @modelInstance.delete(@$scope.model)

      @$scope.save = () ->
        if @$scope.model.id?
          @modelInstance.save(@$scope.model)
        else
          @modelInstance.create(@$scope.model)


  class BaseListModelController extends BaseModelController
    constructor: (@$scope, @$resource, @$routeParams) ->
      console.log "base list const"
      super(@$scope, @$resource, @$routeParams)
      @$scope.models = @modelInstance.list()


  return {
    BaseSingleModelController: BaseSingleModelController
    BaseListModelController: BaseListModelController
  }
