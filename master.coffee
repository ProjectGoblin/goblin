xmlrpc = require 'xmlrpc'

attach_api = require './src/api.coffee'

server = xmlrpc.createServer
  host: 'localhost'
  port: 11311

server.on 'NotFound', (method, params) ->
  console.log "Method #{method}(#{params}) not found"

attach_api server
