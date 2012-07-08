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

Backbone.Router.prototype.route = (route, name, callback) ->
  app.get route, (req, res) =>
    this.res = res
    callback.apply this, _(req.query).values()

Backbone.Router.prototype.render = (view) ->
  layout = fs.readFileSync './views/layout.html'
  $ = cheerio.load(layout)
  $(view.el).html view.toHTML()
  this.res.send $.html()

Backbone.Router.prototype.listen = (port) ->
  app.listen port

Backbone.View.prototype.setElement = ->

