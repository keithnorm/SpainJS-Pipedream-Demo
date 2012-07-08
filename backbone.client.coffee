Backbone = require 'backbone'

Backbone.Router.prototype.render = (view) ->
  view.render()

Backbone.Router.prototype.listen = ->
  $ ->
    Backbone.history.start
      pushState: true
      silent: true

# Backbone requires routes to not be defined with a leading slash
Backbone.Router.prototype._routeToRegExp = do (original = Backbone.Router.prototype._routeToRegExp) ->
  (route) =>
    original.call this, route.replace(/^\//, '')

$ ->
  $('a').live 'click', (e) ->
    e.preventDefault()
    Backbone.history.navigate $(e.target).attr('href'), true

