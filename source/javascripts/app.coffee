require
  paths:
    ember:'../vendor/ember/ember'
    handlebars:'../vendor/handlebars/handlebars'
    jquery: '../vendor/jquery/dist/jquery'
    templates: '../javascripts/templates'
  ['jquery','handlebars', 'ember']
  ->
    App = Ember.Application.create()

    App.Router.map ->

    App.IndexRoute = Ember.Route.extend
      model: ->
        return ['red', 'yellow', 'blue']

