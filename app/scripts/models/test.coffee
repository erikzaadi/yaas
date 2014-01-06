'use strict'

define(['app', 'models/base'], (app, BaseModel) ->
  class TestModel extends BaseModel
    resourceUri: "tests"

  return TestModel
)
