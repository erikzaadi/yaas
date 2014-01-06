'use strict'

define [
  'meta'
  'angular'
  'controllers/base'
  'models/test'
], (meta, angular, baseController, TestModel) ->
  class TestSingleController extends baseController.BaseSingleModelController
    model: TestModel

  class TestListController extends baseController.BaseListModelController
    model: TestModel

  angular
    .module("#{meta.appname}.controllers")
    .controller('TestSingleController', TestSingleController)
    .controller('TestListController', TestListController)

  return {
    TestSingleController: TestSingleController
    TestListController: TestListController
  }
