xmlrpc = require 'xmlrpc'

injectAPI = (require './src/api.coffee').injectAPI

server = xmlrpc.createServer
  host: 'localhost'
  port: 11311

server.on 'NotFound', (method, params) ->
  console.log "Method #{method}(#{params}) not found"

injectAPI server
