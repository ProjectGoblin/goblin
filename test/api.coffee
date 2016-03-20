require '../master.coffee'
(require 'chai').should()
xmlrpc = require 'xmlrpc'
client = xmlrpc.createClient
  host: 'localhost'
  port: 11311
  path: '/'
describe 'ROSMasterAPI', () ->
           

  describe 'deleteParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'deleteParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getParamNames', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getParamNames', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getPid', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getPid', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getPublishedTopics', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getPublishedTopics', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getSystemState', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getSystemState', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getTopicTypes', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getTopicTypes', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getUri', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getUri', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'hasParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'hasParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'lookupNode', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'lookupNode', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'lookupService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'lookupService', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'param_update_task', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'param_update_task', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerPublisher', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerPublisher', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerService', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerSubscriber', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerSubscriber', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'searchParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'searchParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'setParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'setParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'shutdown', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'shutdown', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'subscribeParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'subscribeParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterPublisher', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterPublisher', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterService', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterSubscriber', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterSubscriber', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unsubscribeParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unsubscribeParam', params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        
