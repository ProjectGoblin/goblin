require '../master.coffee'
_ = require 'underscore'
kv = require '../src/kv.coffee'
async = require 'async'
consul = (require 'consul')()
chai = require 'chai'
should = chai.should()
xmlrpc = require 'xmlrpc'
client = xmlrpc.createClient
  host: 'localhost'
  port: 11311
  path: '/'
describe 'ROSMasterAPI', () ->
  # Set up & clean up
  kvClear = (done) -> consul.kv.del {key: '', recurse: true}, done
  before kvClear
  after kvClear

  # Parameter Server
  describe 'setParam', () ->
    it 'should set singe value correctly', (done) ->
      key = 'foo'
      value = 42
      client.methodCall 'setParam', [0, key, value], (err, response) ->
        should.not.exist err
        [code, desc, rtv] = response
        code.should.equal 1
        desc.should.equal "Parameter set: [#{key}] => [#{value}]"
        rtv.should.equal  0
        consul.kv.get {key: key, recurse: true}, (err, data) ->
          should.not.exist err
          data.should.have.length 1
          data[0].Value.should.equal JSON.stringify value
          done()

    it 'should set parameter tree correctly', (done) ->
      key = 'ns'
      tree =
        foo: 42
        bar: false
        baz:
          rgb: '#66CCFF'
      client.methodCall 'setParam', [0, key, tree], (err, response) ->
        should.not.exist err
        [code, desc, rtv] = response
        code.should.equal 1
        desc.should.equal "Parameter set: [#{key}] => [#{tree}]"
        rtv.should.equal  0
        consul.kv.get {key: key, recurse: true}, (err, data) ->
          sortByKey = (xs) -> _.sortBy xs, (x) -> x.Key
          pairs = kv.expandTree key, tree
          pairs.should.be.a('Array')
          should.not.exist err
          data.should.have.length pairs.length
          for couple in _.zip (sortByKey data), (sortByKey pairs)
            couple[0].Value.should.equal couple[1].Value
          done()

  describe 'getParam', () ->
    it 'should returns a single value when requiring a name', (done) ->
      key = 'ns/foo'
      client.methodCall 'getParam', [0, key], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "Parameter [#{key}]"
        value.should.equal 42
        done()

    it 'should returns a parameter tree when requiring a namespace', (done) ->
      key = 'ns'
      tree =
        foo: 42
        bar: false
        baz:
          rgb: '#66CCFF'
      client.methodCall 'getParam', [0, key], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "Parameter [#{key}]"
        value.should.eql tree
        done()

    it 'should raise an error when requiring a not-existing name', (done) ->
      key = 'not-exists'
      client.methodCall 'getParam', [0, key], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal -1
        desc.should.equal "Parameter [#{key}] not exists"
        value.should.equal 0
        done()

  describe 'getParamNames', () ->
    it 'should returns all parameters\' names', (done) ->
      client.methodCall 'getParamNames', [], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.be.a 'string'
        value.sort().should.eql ['foo', 'ns/bar', 'ns/baz/rgb', 'ns/foo'].sort()
        done()

  describe 'deleteParam', () ->
    testUnit = (key, detector) -> (done) ->
      client.methodCall 'deleteParam', [0, key], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.be.a 'string'
        client.methodCall 'getParamNames', null, (err, res) ->
          should.not.exist err
          should.not.exist (res[2].find detector)
          done()
    it 'should delete parameter correctly', (testUnit 'ns/bar', (x) -> x == 'ns/bar')
    it 'should delete parameter recursively', (testUnit 'ns', (x) -> x.startsWith 'ns')

  describe 'hasParam', () ->
    withKeySet = (key, value, testcase) -> (done) ->
      client.methodCall 'setParam', [0, key, value], (err, response) ->
        should.not.exist err
        should.exist response
        testcase done

    testUnit = (key, exist) -> (done) ->
      client.methodCall 'hasParam', [0, key], (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal key
        value.should.equal exist
        done()

    it 'should returns true on an existing name',
      withKeySet 'name/a', 42, testUnit 'name/a', true
    it 'should returns false on a not-existing name',
      testUnit 'name/b', false
    it 'should returns true on an existing namespace',
      withKeySet 'nsx',{y:25, z: 26} , testUnit 'nsx', true
    it 'should returns false on a not-existing namespace', testUnit 'nsy', false

  describe 'getPid', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getPid', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getPublishedTopics', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getPublishedTopics', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getSystemState', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getSystemState', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getTopicTypes', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getTopicTypes', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'getUri', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'getUri', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        


  describe 'lookupNode', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'lookupNode', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'lookupService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'lookupService', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'param_update_task', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'param_update_task', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerPublisher', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerPublisher', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerService', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'registerSubscriber', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'registerSubscriber', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()


  describe 'searchParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'searchParam', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()


  describe 'shutdown', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'shutdown', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'subscribeParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'subscribeParam', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterPublisher', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterPublisher', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterService', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterService', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unregisterSubscriber', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unregisterSubscriber', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        

  describe 'unsubscribeParam', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall 'unsubscribeParam', params, (err, response) ->
        should.not.exist err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        
