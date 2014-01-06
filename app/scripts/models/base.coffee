'use strict'

class BaseModel
  resourceUri: ""
  resource: null
  constructor: (resource, apiBaseUri) ->
    apiBaseUri ?= "/api/v1" #TODO: take from const?
    console.log "base model const"
    @resource = resource "#{apiBaseUri}/#{@resourceUri}/:modelId", { 
      modelId: '@modelId' 
    } , {
      query: 
        method:'GET'
        params:
          modelId:''
        isArray:true
      }

  list: ->
    @resource.query()

  get: (id, cb, err) ->
    @resource.get {modelId:id}, cb, err

  empty: ->
    new @resource

  create: (model, cb, err) ->
    @resource.create model, cb, err
    
  save: (model, cb, err) ->
    @resource.update model, cb, err

  delete: (model, cb, err) ->
    @resource.delete model, cb, err

#do as factory?

define ['meta', 'angular'], (meta)->
  angular.module("#{meta.appname}.models", [])
  return BaseModel
