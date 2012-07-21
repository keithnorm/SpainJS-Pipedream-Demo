var socket = io.connect('http://localhost:3030');

socket.on('file:change', function() {
  var Backbone = require('backbone');
  require.cache = {};
  $.getScript('/js/app.js', function() {
    Backbone = require('backbone');
    Backbone.history.loadUrl(window.location.pathname);
  });
});

