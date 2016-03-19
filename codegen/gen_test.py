def generate_test(apis):
    src = ["""
(require 'chai').should()
xmlrpc = require 'xmlrpc'
client = xmlrpc.createClient
  host: 'localhost'
  port: 11311
  path: '/'
describe 'ROSMasterAPI', () ->
           """]
    for name in sorted(apis.keys()):
        src.append("""
  describe '{}', () ->
    it 'should works like echo', (done) ->
      params = ['param']
      client.methodCall {!r}, params, (err, response) ->
        if err then throw err
        [code, desc, value] = response
        code.should.equal 1
        desc.should.equal "success"
        value.should.eql  params
        done()
        """.format(name, name))
    return '\n'.join(src)

