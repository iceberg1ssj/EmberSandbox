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
    peerjs: '../vendor/peerjs/peer'
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
        today = new Date();
        today_abs = new Date()
        today_abs.setHours(0)
        today_abs.setMinutes(0)
        today_abs.setSeconds(0)
        today_secs = (today.getTime() - today_abs.getTime()) / 1000
        today_remaining=86500 - today_secs

        $(".dial").knob {
          min:0
          max:86500
          fgColor: '#e59f63'
          change: ->
            today = new Date();
            today_abs = new Date()
            today_abs.setHours(0)
            today_abs.setMinutes(0)
            today_abs.setSeconds(0)
            today_secs = (today.getTime() - today_abs.getTime()) / 1000
            today_remaining=86500 - today_secs
            if $(".dial").val() >= today_remaining
              $(".dial").val(today_remaining)
            console.log($(".dial").val() >= today_remaining)
        }
        client= new peer({host:'localhost', port: 9000})
        client.on 'open',(id) ->
          console.log('My peer ID is: ' + id)

        $(".dial").val(today_remaining)
        setInterval ->
          $(".dial").val($(".dial").val()-1).trigger('change')
        ,1000
        require ['setupRotatingGlobe']
        ###
        setTimeout(->
           console.log('stuff')
           require 'setupRotatingGlobe'
        ,1500)
        ###
