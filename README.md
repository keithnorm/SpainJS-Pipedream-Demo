# Pipedream demo app from SpainJS talk

This is an example of a Backbone app that runs the same code on the server via Node.js and on the client. 

You can watch the video of the presentation here: [The Pipedream of Sharing Code Between Node and the Browser](http://www.youtube.com/watch?v=jbn9c_yfuoM)

To run the app, install node and npm, then run `npm install`

If you alter server.coffee, you will need to regenerate the browserified file (public/js/app.js). To regenerate that file run
    
    node_modules/browserify/bin/cmd server.coffee -o public/js/app.js -i ./backbone.server -i socket.io

