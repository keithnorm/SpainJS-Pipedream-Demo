# 1) include express
# 2) make Router#route delegate to express
# 3) implement Router#render override for server
# 4) implement View#toHTML
# 5) noop View#setElement

_ = require 'underscore'
Backbone = require 'backbone'

fs = require 'fs'
express = require 'express'
app = express()
cheerio = require 'cheerio'

app.use express.static(__dirname + '/public')

Backbone.sync = require './server.sync'

Backbone.Router.prototype.route = (route, name) ->
  app.get route, (req, res) =>
    this.res = res
    callback = this[this.routes[route]]
    callback.apply this, _(req.query).values()

Backbone.Router.prototype.render = (view) ->
  layout = fs.readFileSync './views/layout.html'
  $ = cheerio.load(layout)
  $(view.el).html view.toHTML()
  this.res.send $.html()

Backbone.Router.prototype.listen = (port) ->
  app.listen port

Backbone.View.prototype.setElement = ->


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

bundle.ignore ['express', './lib/router.server', 'Templates', 'request', './reloader', 'fs', 'browserify', 'fileify', 'socket.io', 'cheerio']

templates = fileify('Templates', process.cwd() + '/views', watch: true)

bundle.use templates

bundle.addEntry "./server.coffee"

bundle.on 'bundle', ->
  fs.writeFile './public/js/app.js', bundle.bundle(), ->
    socket.emit 'file:change' if socket.emit?

