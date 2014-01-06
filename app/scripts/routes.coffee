'use strict'
define([
  'app'
  'meta'
  'templates'
  'controllers/home'
  'controllers/test'
], (app, meta, templates, HomeCtrl, testsController) ->
  angular.module(meta.appname)
    .config(
      [
        "$routeProvider", 
        ($routeProvider) ->
          modelControllers = [
            "Test": testsController
          ]

          modelControllers.forEach (controller) =>
            for controllerName, controllerHolder of controller
              controllerUri = "#{controllerName.toLowerCase()}s"
              singleController = controllerHolder["#{controllerName}SingleController"]
              multipleController = controllerHolder["#{controllerName}ListController"]

              $routeProvider
                .when "/#{controllerUri}",
                  templateUrl: "views/#{controllerUri}/list"
                  controller: multipleController
                .when "/#{controllerUri}/new",
                  templateUrl: "views/#{controllerUri}/new"
                  controller: singleController
                .when "/#{controllerUri}/:modelId",
                  templateUrl: "views/#{controllerUri}/single"
                  controller: singleController
                .when "/#{controllerUri}/:modelId/edit",
                  templateUrl: "views/#{controllerUri}/edit"
                  controller: singleController
                .when "/#{controllerUri}/:modelId/delete",
                  templateUrl: "views/#{controllerUri}/delete"
                  controller: singleController


          $routeProvider
            .when '/',
              templateUrl: 'views/home'
              controller: HomeCtrl
            .otherwise
              redirectTo: '/'
      ]
    )
  )
