# to regen the browserify file run this:
# node_modules/browserify/bin/cmd server.coffee -o public/js/app.js -i ./backbone.server
_ = require 'underscore'
Backbone = require 'backbone'

hogan = require 'hogan.js'

if process.browser
  require './backbone.client'
else
  require './backbone.server' 

  # this starts the auto reloader code
  socket = {}

  browserify = require 'browserify'
  fileify = require 'fileify'
  fs = require 'fs'

  bundle = browserify
    watch: true
    cache: false
    debug: false
    exports: false

  bundle.ignore ['express', './lib/router.server', 'Templates', 'request', './reloader', 'fs', 'browserify', 'fileify', 'socket.io']

  templates = fileify('Templates', process.cwd() + '/views', watch: true)

  bundle.use templates

  bundle.addEntry "./server.coffee"

  bundle.on 'bundle', ->
    fs.writeFile './public/js/app.js', bundle.bundle(), ->
      socket.emit 'file:change' if socket.emit?

class Router extends Backbone.Router
  routes:
    '/': 'root'
    '/about': 'about'

  root: ->
    tweets = new Tweets()
    tweets.fetch
      success: (tweets, response) =>
        this.render new HomeView
          tweets: tweets.models
    
  about: ->
    this.render new AboutView()

class Tweets extends Backbone.Collection
  url: 'http://search.twitter.com/search.json?q=spainjs&rpp=10&include_entities=true&result_type=recent&callback=?'

  parse: (response) ->
    response.results

class HomeView extends Backbone.View
  el: '#main'

  template: """
    <h1>Spain JS RULES!</h1>
    <ul>
      {{# tweets }}
        <li>{{ attributes.text }}</li>
      {{/ tweets }}
    </ul>
    """

  initialize: (options)->
    @tweets = options.tweets

  toHTML: ->
    template = hogan.compile @template
    template.render this

  render: ->
    @$el.fadeOut 'fast', =>
      @$el.html this.toHTML()
      this.delegateEvents()
      @$el.fadeIn()

class AboutView extends Backbone.View
  el: '#main'
  template: """
    <h2>A summer javascript conference in Spain</h2>
    <h3>July 5-7, 2012 - Florida Park (Parque del Retiro) Madrid</h3>
    """

  toHTML: ->
    @template

  render: ->
    @$el.fadeOut 'fast', =>
      @$el.html this.toHTML()
      this.delegateEvents()
      @$el.fadeIn()
      
router = new Router()

server = router.listen 3030

unless process.browser
  io = require('socket.io').listen server

  io.sockets.on 'connection', (sock) ->
    socket = sock

