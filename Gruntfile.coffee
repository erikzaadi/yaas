"use strict"
module.exports = (grunt) ->

  pushState = require('grunt-connect-pushstate/lib/utils').pushState
  npm_package = grunt.file.readJSON('package.json')

  version = npm_package['version']
  appname = npm_package['name']

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    appname: appname
    version: version 
    vendor: "app/vendor"
    build: "build"
    dist: "dist"

  try
    yeomanConfig.src = require("./bower.json").appPath or yeomanConfig.src

  grunt.initConfig

    yo: yeomanConfig

    template:
      dev:
        options:
          data:
            debug: 'true'
            appname: yeomanConfig.appname
            version: yeomanConfig.version
         files:
          "<%= yo.build %>/scripts/meta.js": "<%= yo.app %>/scripts/meta.tpl"
      prod:
        options:
          data:
            debug: 'false'
            appname: yeomanConfig.appname
            version: yeomanConfig.version

        files:
          "<%= yo.build %>/scripts/meta.js": "<%= yo.app %>/scripts/meta.tpl"

    watch:
      options:
        livereload: true
        nospawn: true
      coffee:
        files: ["<%= yo.app %>/scripts/**/{,*/}*.coffee"]
        tasks: ["coffee:build"]
        options:
          events: ['changed', 'added']
      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test", "karma:unit:run"]
      stylus:
        files: ["<%= yo.app %>/styles/{,*/}*.styl"]
        tasks: ["stylus"]
      jade:
        files: ["<%= yo.app %>/**/{,*/}*.jade"]
        tasks: ['jade', 'ngtemplates']
      template:
        files: ["<%= yo.app %>/scripts/*.tpl"]
        tasks: ['template']

    connect:
      options:
        port: 9000
        hostname: 'localhost'
        middleware: (connect, options) ->
          [
            pushState()
            connect.static(options.base)
          ]
      dev:
        options:
          base: yeomanConfig.build
      production:
        options:
          base: yeomanConfig.dist

    open:
      server:
        url: "http://<%= connect.options.hostname %>:<%= connect.options.port %>"

    clean:
      dist: "<%= yo.dist %>"
      build: "<%= yo.build %>"

    coffee:
      # options:
      #   sourceMap: yes
      #   sourceRoot: './'
      build:
        expand: true
        cwd: "<%= yo.app %>/scripts"
        src: "**/{,*/}*.coffee"
        dest: "<%= yo.build %>/scripts"
        ext: ".js"
      test:
        expand: true
        cwd: "test"
        src: "**/{,*/}*.coffee"
        dest: "<%= yo.build %>"
        ext: ".js"

    stylus: 
      compile: 
        options: 
          paths: ['<%= yo.app %>/styles']
          use: [
            require('nib') 
          ]
          import: [  
            "../vendor/font-awesome/css/font-awesome.css"
            "../vendor/bootstrap-stylus/stylus/bootstrap"
            'nib'
          ]
          'include css': true
          define: 
            '$icon-font-path': '../fonts/'
        files: 
          '<%= yo.build %>/styles/app.css': ['<%= yo.app %>/styles/{,*/}*.styl']

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yo.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yo.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yo.dist %>/styles/app.css": [
            "<%= yo.build %>/styles/{,*/}*.css",
            "<%= yo.app %>/styles/{,*/}*.css"
          ]

    htmlmin:
      dist:
        removeCommentsFromCDATA: true
        # https://github.com/yeoman/grunt-usemin/issues/44
        collapseWhitespace: true
        collapseBooleanAttributes: true
        removeAttributeQuotes: true
        removeRedundantAttributes: true
        useShortDoctype: true
        removeEmptyAttributes: true
        removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yo.build %>"
          src: ["*.html"]
          dest: "<%= yo.dist %>"
        ]

    ngmin:
      dist:
        files: [
          expand: true,
          src: ["<%= yo.build %>/scripts/{,*/}*.js"]
        ]

    requirejs:
      compile:
        options:
          name: "main"
          baseUrl: "<%= yo.build %>/scripts"
          mainConfigFile: "<%= yo.build %>/scripts/main.js"
          out: "<%= yo.dist %>/scripts/main.js"

    useminPrepare:
      html: "<%= yo.build %>/index.html"
      dest: "<%= yo.dist %>"

    usemin:
      html: ["<%= yo.dist %>/{,*/}*.html"]
      css: ["<%= yo.dist %>/styles/{,*/}*.{/}*.css"]

    rev:
      dist:
        files:
          src: [
            "<%= yo.dist %>/scripts/{,*/}*.js"
            "<%= yo.dist %>/styles/{,*/}*.css"
            "<%= yo.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= yo.dist %>/styles/fonts/*"
          ]

    copy:
      build:
        files: [
          {
            expand: true
            dot: false
            cwd: "<%= yo.app %>"
            dest: "<%= yo.build %>"
            src: [
              "index.html"
              "vendor/*/*.js"
              "vendor/bootstrap-stylus/js/**"
              "vendor/font-awesome/css/**"
              "vendor/json3/lib/*.js"
              "!vendor/**/*.min.js"
              "!vendor/**/Gruntfile.js"
            ]
          }
          ,{
            expand: true
            flatten: true
            dot: false
            cwd: "<%= yo.app %>"
            dest: "<%= yo.build %>/fonts/"
            src: [
              "vendor/bootstrap-stylus/fonts/*"
              "vendor/font-awesome/fonts/*"
            ]
          }
        ]
      test:
        files: [
          expand: true, dot: false, cwd: "<%= yo.app %>", dest: "<%= yo.build %>",
          src: [
            "vendor/*/*.js", "vendor/json3/lib/*.js",
            "!vendor/**/*.min.js", "!vendor/**/Gruntfile.js",
          ]
        ]
      dist:
        files: [
          {
            expand: true, dot: false, cwd: "<%= yo.app %>", dest: "<%= yo.dist %>",
            src: ["*.{ico,txt}", "images/{,*/}*.{gif,webp}", "vendor/requirejs/require.js"]
          },
          {
            expand: true
            flatten: true
            dot: false
            cwd: "<%= yo.app %>"
            dest: "<%= yo.dist %>/fonts/"
            src: [
              "vendor/bootstrap-stylus/fonts/*"
              "vendor/font-awesome/fonts/*"
            ]
          }
        ]

    karma:
      options:
        basePath: "<%= yo.build %>"
        configFile: "karma.conf.js"
      unit:
        background: true
        browsers: ['Chrome']
      ci:
        singleRun: true
        browsers: ["PhantomJS"]

    ngtemplates:      
      app:            
        cwd: "<%= yo.build %>"
        src: "views/{,*/}*.html"
        dest: "<%= yo.build %>/scripts/templates.js"
        options:      
          htmlmin: "<%= htmlmin.dist %>"
          url: (url) ->
             url.replace('<%= yo.build %>', '').replace('.html', '')
          bootstrap:  (module, script) ->
            "(function() {
  'use strict';
  define(['angular', '#{module}'], function() {
    angular.module('#{yeomanConfig.appname}').run(['$templateCache', function($templateCache) {
#{script}
      }]);
    })}).call(this);"

    jade: 
      dist: 
        options: 
          pretty: true
          compileDebug: true
          client: false
        files: [
          expand: true
          cwd: "<%= yo.app %>"
          dest: "<%= yo.build %>"
          src: "**/*.jade"
          ext: '.html'
        ]

  # just recreate changed coffee file
  changedFiles = Object.create(null);
  onChange = grunt.util._.debounce(->
    grunt.config 'coffee.build.src', Object.keys(changedFiles)
    changedFiles = Object.create(null);
  , 200);
  grunt.event.on 'watch', (action, filepath, target) ->
    if grunt.file.isMatch grunt.config('watch.coffee.files'), filepath
      filepath = filepath.replace( grunt.config('coffee.build.cwd')+'/', '' );
      changedFiles[filepath] = action;
      onChange();


  # compile coffee-script, stylus, jade etc
  grunt.registerTask "compile", ["coffee", "stylus", "jade", "ngtemplates"]
  # build all stuff for development and ready for production
  grunt.registerTask "build", ["clean:build", "compile", "copy:build"]
  # build production stuff
  grunt.registerTask "min", ["useminPrepare", "imagemin", "concat", "cssmin", "htmlmin", "ngmin", "requirejs", "rev", "usemin"]

  # for travis, CI testing
  grunt.registerTask "ci", ["build", "template:dev", "copy:test", "karma:ci"]
  # run testing while there is any things be changed
  grunt.registerTask "autotest", ["karma:unit", "watch"]

  # setup development env, autocompile, livereload and open the browers.
  grunt.registerTask "dev", ["build", "template:dev", "connect:dev", "open", "watch"]
  # simulate production env.
  grunt.registerTask "dist", ["clean:dist", "build", "template:prod", "stylus", "copy:build", "min", "copy:dist", "connect:production", "open", "watch"]

  grunt.registerTask "default", ["dev"]
