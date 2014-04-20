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
  ['jquery','handlebars', 'ember','d3']
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
        require ['setupRotatingGlobe']
        ###
        setTimeout(->
           console.log('stuff')
           require 'setupRotatingGlobe'
        ,1500)
        ###

###
        autorotate= (degPerSec, planetaryjs) ->
          (planet) ->
            lastTick = null
            paused = false
            planet.plugins.autorotate =
              pause:  ->
                paused = true
              resume: ->
                paused = false


            planet.onDraw ->
              if paused || !lastTick
                lastTick = new Date()
              else
                now = new Date()
                delta = now - lastTick
                rotation = planet.projection.rotate()
                rotation[0] += degPersSec * delta / 1000
                if (rotation[0] >= 180)
                  rotation[0] -= 360
                planet.projection.rotate(rotation)
                lastTick = now;
        planetaryjs= require 'planetary'
        globe= planetaryjs.planet();
        globe.loadPlugin(autorotate(10,planetaryjs))

        globe.loadPlugin planetaryjs.plugins.earth
          topojson:
            file:   '/world-110m-withlakes.json'
          oceans:
            fill:   '#000080'
          land:
            fill:   '#339966'
          borders:
            stroke: '#008000'

        globe.loadPlugin
          lakes:
            fill: '#000080'


        globe.loadPlugin planetaryjs.plugins.zoom
          scaleExtent: [100, 300]

        globe.loadPlugin planetaryjs.plugins.drag
          onDragStart: ->
            this.plugins.autorotate.pause()
          onDragEnd: ->
            this.plugins.autorotate.resume()

        colors = ['red', 'yellow', 'white', 'orange', 'green', 'cyan', 'pink'];
        setInterval(->
            lat = Math.random() * 170 - 85
            lng = Math.random() * 360 - 180
            color = colors[Math.floor(Math.random() * colors.length)]
            globe.plugins.pings.add(lng, lat, { color: color, ttl: 2000, angle: Math.random() * 10 })
          150
        )

        canvas= document.getElementById('globe')

        if window.devicePixelRatio == 2
          canvas.width = 800
          canvas.height = 800
          context = canvas.getContext('2d')
          context.scale(2, 2)
        globe.draw(canvas)



      lakes: (options) ->
        options = options || {}
        lakes = null

        return (planet) ->
          planet.onInit ->
            world = planet.plugins.topojson.world
            lakes = topojson.feature(world, world.objects.ne_110m_lakes)

        planet.onDraw ->
          planet.withSavedContext (context) ->
            context.beginPath()
            planet.path.context(context)(lakes)
            context.fillStyle = options.fill || 'black'
            context.fill()

###