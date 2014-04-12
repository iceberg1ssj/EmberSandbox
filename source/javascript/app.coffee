require
  paths:
    ember:'../vendor/ember/ember'
    handlebars:'../vendor/handlebars/handlebars'
    jquery: '../vendor/jquery/dist/jquery'
  ['jquery','handlebars', 'ember']
  ($, handlebars, ember)->
    App = Ember.Application.create()

    App.Router.map ->

    App.IndexRoute = Ember.Route.extend
      model: ->
        return ['red', 'yellow', 'blue']

