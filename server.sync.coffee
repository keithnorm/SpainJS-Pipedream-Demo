_ = require 'underscore'
request = require 'request'

module.exports = (method, model, options) ->
  getUrl = (object) ->
    return null unless object and object.url
    (if _.isFunction(object.url) then object.url() else object.url)

  params = options
  params.url = getUrl(model) or urlError()  unless params.url
  request.get params.url, (error, response, body) ->
    params.success JSON.parse(body)


