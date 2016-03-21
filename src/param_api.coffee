_ = require 'underscore'
kv = require './kv.coffee'
async = require 'async'
consul = (require 'consul')()

module.exports = (server) ->

# Parameter Server

# Parameter Server: set parameter.  NOTE: if value is a
# dictionary it will be treated as a parameter tree, where key
# is the parameter namespace. For example:::
# {'x':1,'y':2,'sub':{'z':3}}
#
# will set key/x=1, key/y=2, and key/sub/z=3. Furthermore, it
# will replace all existing parameters in the key parameter
# namespace with the parameters in value. You must set
# parameters individually if you wish to perform a union update.
#
# @param caller_id: ROS caller id
# @type  caller_id: str
# @param key: parameter name
# @type  key: str
# @param value: parameter value.
# @type  value: XMLRPCLegalValue
# @return: [code, msg, 0]
# @rtype: [int, str, int]
  server.on 'setParam', (err, params, callback) ->
    [caller_id, key, value] = params
    pairs = kv.expandTree key, value
    async.map pairs, ((p, cb) -> consul.kv.set p, cb), (err, results) ->
      if err
        msg = "Failed setting parameter [#{key}] => [#{value}]: #{err}"
        callback null, [-1, msg , 0]
      status = _.filter results, (x) -> x isnt true
      if status.length != 0
        msg = "Failed setting parameter [#{key}] => [#{value}]: #{status}"
        callback null, [-1, msg, 0]
      else
        msg = "Parameter set: [#{key}] => [#{value}]"
        callback null, [1, msg, 0]

  # Retrieve parameter value from server.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param key: parameter to lookup. If key is a namespace,
  # getParam() will return a parameter tree.
  # @type  key: str
  # getParam() will return a parameter tree.
  #
  # @return: [code, statusMessage, parameterValue]. If code is not
  # 1, parameterValue should be ignored. If key is a namespace,
  # the return value will be a dictionary, where each key is a
  # parameter in that namespace. Sub-namespaces are also
  # represented as dictionaries.
  # @rtype: [int, str, XMLRPCLegalValue]
  server.on 'getParam', (err, params, callback) ->
    [caller_id, key] = params
    consul.kv.get {key: key, recurse: true}, (err, data, res) ->
      if err
        callback err, res
      if data is undefined
        callback null, [-1, "Parameter [#{key}] not exists", 0]
      else
        value = kv.parseQuery data
        callback null, [1, "Parameter [#{key}]", value[key]]

  # Get list of all parameter names stored on this server.
  # This does not adjust parameter names for caller's scope.
  #
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @return: [code, statusMessage, parameterNameList]
  # @rtype: [int, str, [str]]
  server.on 'getParamNames', (err, params, callback) ->
    consul.kv.keys (err, names, res) ->
      if err
        callback err, res
      else
        callback null, [1, "Parameter names", names]

  # Parameter Server: delete parameter
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param key: parameter name
  # @type  key: str
  # @return: [code, msg, 0]
  # @rtype: [int, str, int]
  server.on 'deleteParam', (err, params, callback) ->
    [caller_id, key] = params
    consul.kv.del {key: key, recurse: true}, (err, data, res) ->
      if err
        callback err, res
      else
        callback null, [1, "Parameter [#{key}] deleted", 0]

  # Check if parameter is stored on server.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param key: parameter to check
  # @type  key: str
  # @return: [code, statusMessage, hasParam]
  # @rtype: [int, str, bool]
  server.on 'hasParam', (err, params, callback) ->
    detecor = (key) -> (name) ->
      name == key or name.startsWith "#{key}/"

    [caller_id, key] = params
    consul.kv.keys (err, names, res) ->
      if err
        callback err, res
      else
        callback null, [1, key, (names.find detecor key) isnt undefined]

  # Search for parameter key on parameter server. Search starts in caller's namespace and proceeds
  # upwards through parent namespaces until Parameter Server finds a matching key.
  #
  # searchParam's behavior is to search for the first partial match.
  # For example, imagine that there are two 'robot_description' parameters::
  #
  # /robot_description
  # /robot_description/arm
  # /robot_description/base
  # /pr2/robot_description
  # /pr2/robot_description/base
  #
  # If I start in the namespace /pr2/foo and search for
  # 'robot_description', searchParam will match
  # /pr2/robot_description. If I search for 'robot_description/arm'
  # it will return /pr2/robot_description/arm, even though that
  # parameter does not exist (yet).
  #
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param key: parameter key to search for.
  # @type  key: str
  # @return: [code, statusMessage, foundKey]. If code is not 1, foundKey should be
  # ignored.
  # @rtype: [int, str, str]
  server.on 'searchParam', (err, params, callback) ->
    callback null, [1, "success", params]

  # Retrieve parameter value from server and subscribe to updates to that param. See
  # paramUpdate() in the Node API.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param key: parameter to lookup.
  # @type  key: str
  # @param caller_api: API URI for paramUpdate callbacks.
  # @type  caller_api: str
  # @return: [code, statusMessage, parameterValue]. If code is not
  # 1, parameterValue should be ignored. parameterValue is an empty dictionary if the parameter
  # has not been set yet.
  # @rtype: [int, str, XMLRPCLegalValue]
  server.on 'subscribeParam', (err, params, callback) ->
    callback null, [1, "success", params]

  # Retrieve parameter value from server and subscribe to updates to that param. See
  # paramUpdate() in the Node API.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param key: parameter to lookup.
  # @type  key: str
  # @param caller_api: API URI for paramUpdate callbacks.
  # @type  caller_api: str
  # @return: [code, statusMessage, numUnsubscribed].
  # If numUnsubscribed is zero it means that the caller was not subscribed to the parameter.
  # @rtype: [int, str, int]
  server.on 'unsubscribeParam', (err, params, callback) ->
    callback null, [1, "success", params]

  server.on 'param_update_task', (err, params, callback) ->
    callback null, [1, "success", params]

