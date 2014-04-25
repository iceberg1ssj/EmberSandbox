require
  shim:
    'planetaryjs':
      exports:'planetaryjs'
    'setupRotatingGlobe':
      deps:['planetaryjs']
  paths:
    ember:'../vendor/ember/ember'
    handlebars:'../vendor/handlebars/handlebars'
    jquery: '../vendor/jquery/dist/jquery'
    templates: '../javascripts/templates'
    planetaryjs: '../vendor/planetary.js/dist/planetaryjs'
    d3: '../vendor/d3/d3'
    topojson: '../vendor/topojson/topojson'
    setupRotatingGlobe:'../vendor/planetary.js/script/setup.rotating.globe'
    knob:'../vendor/jquery-knob/js/jquery.knob'
  ['jquery','handlebars', 'ember','d3', 'knob']
  ->
    App = Ember.Application.create()

    App.Router.map ->

    App.IndexRoute = Ember.Route.extend
      model: ->
        return ['red', 'yellow', 'blue']
      renderTemplate: ->
        Ember.run.scheduleOnce('afterRender', this, 'setupGlobe')
        @render()


      setupGlobe:->
        $(".dial").knob()
        require ['setupRotatingGlobe']
        ###
        setTimeout(->
           console.log('stuff')
           require 'setupRotatingGlobe'
        ,1500)
        ###
