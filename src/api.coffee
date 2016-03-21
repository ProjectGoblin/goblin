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
  server.on 'getParam', (err, key, callback) ->
    consul.kv.get {key: key, recurse: true}, (err, data, res) ->
      if err isnt undefined
        callback err, res
      if value is undefined
        callback null, [-1, "Parameter [#{key}] is not set", 0]
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
    callback null, [1, "success", params]

  # Parameter Server: delete parameter
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param key: parameter name
  # @type  key: str
  # @return: [code, msg, 0]
  # @rtype: [int, str, int]
  server.on 'deleteParam', (err, params, callback) ->
    callback null, [1, "success", params]

  # Get the PID of this server
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @return: [1, "", serverProcessPID]
  # @rtype: [int, str, int]
  server.on 'getPid', (err, params, callback) ->
    callback null, [1, "success", params]

  # Get list of topics that can be subscribed to. This does not return topics that have no publishers.
  # See L{getSystemState()} to get more comprehensive list.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param subgraph: Restrict topic names to match within the specified subgraph. Subgraph namespace
  # is resolved relative to the caller's namespace. Use '' to specify all names.
  # @type  subgraph: str
  # @return: (code, msg, [[topic1, type1]...[topicN, typeN]])
  # @rtype: (int, str, [[str, str],])
  server.on 'getPublishedTopics', (err, params, callback) ->
    callback null, [1, "success", params]

  # Retrieve list representation of system state (i.e. publishers, subscribers, and services).
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @rtype: (int, str, [[str,[str]], [str,[str]], [str,[str]]])
  # @return: (code, statusMessage, systemState).
  # 
  # System state is in list representation::
  # [publishers, subscribers, services].
  # 
  # publishers is of the form::
  # [ [topic1, [topic1Publisher1...topic1PublisherN]] ... ]
  # 
  # subscribers is of the form::
  # [ [topic1, [topic1Subscriber1...topic1SubscriberN]] ... ]
  # 
  # services is of the form::
  # [ [service1, [service1Provider1...service1ProviderN]] ... ]
  server.on 'getSystemState', (err, params, callback) ->
    callback null, [1, "success", params]

  # Retrieve list topic names and their types.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @rtype: (int, str, [[str,str]] )
  # @return: (code, statusMessage, topicTypes). topicTypes is a list of [topicName, topicType] pairs.
  server.on 'getTopicTypes', (err, params, callback) ->
    callback null, [1, "success", params]

  # Get the XML-RPC URI of this server.
  # @param caller_id str: ROS caller id
  # @return [int, str, str]: [1, "", xmlRpcUri]
  server.on 'getUri', (err, params, callback) ->
    callback null, [1, "success", params]

  # Check if parameter is stored on server.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param key: parameter to check
  # @type  key: str
  # @return: [code, statusMessage, hasParam]
  # @rtype: [int, str, bool]
  server.on 'hasParam', (err, params, callback) ->
    callback null, [1, "success", params]

  # Get the XML-RPC URI of the node with the associated
  # name/caller_id.  This API is for looking information about
  # publishers and subscribers. Use lookupService instead to lookup
  # ROS-RPC URIs.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param node: name of node to lookup
  # @type  node: str
  # @return: (code, msg, URI)
  # @rtype: (int, str, str)
  server.on 'lookupNode', (err, params, callback) ->
    callback null, [1, "success", params]

  # Lookup all provider of a particular service.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param service: fully-qualified name of service to lookup.
  # @type: service: str
  # @return: (code, message, serviceUrl). service URL is provider's
  # ROSRPC URI with address and port.  Fails if there is no provider.
  # @rtype: (int, str, str)
  server.on 'lookupService', (err, params, callback) ->
    callback null, [1, "success", params]


  server.on 'param_update_task', (err, params, callback) ->
    callback null, [1, "success", params]

  # Register the caller as a publisher the topic.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param topic: Fully-qualified name of topic to register.
  # @type  topic: str
  # @param topic_type: Datatype for topic. Must be a
  # package-resource name, i.e. the .msg name.
  # @type  topic_type: str
  # @param caller_api str: ROS caller XML-RPC API URI
  # @type  caller_api: str
  # @return: (code, statusMessage, subscriberApis).
  # List of current subscribers of topic in the form of XMLRPC URIs.
  # @rtype: (int, str, [str])
  server.on 'registerPublisher', (err, params, callback) ->
    callback null, [1, "success", params]

  # Register the caller as a provider of the specified service.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param service: Fully-qualified name of service
  # @type  service: str
  # @param service_api: Service URI
  # @type  service_api: str
  # @param caller_api: XML-RPC URI of caller node
  # @type  caller_api: str
  # @return: (code, message, ignore)
  # @rtype: (int, str, int)
  server.on 'registerService', (err, params, callback) ->
    callback null, [1, "success", params]

  # Subscribe the caller to the specified topic. In addition to receiving
  # a list of current publishers, the subscriber will also receive notifications
  # of new publishers via the publisherUpdate API.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param topic str: Fully-qualified name of topic to subscribe to.
  # @param topic_type: Datatype for topic. Must be a package-resource name, i.e. the .msg name.
  # @type  topic_type: str
  # @param caller_api: XML-RPC URI of caller node for new publisher notifications
  # @type  caller_api: str
  # @return: (code, message, publishers). Publishers is a list of XMLRPC API URIs
  # for nodes currently publishing the specified topic.
  # @rtype: (int, str, [str])
  server.on 'registerSubscriber', (err, params, callback) ->
    callback null, [1, "success", params]

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

  # Stop this server
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param msg: a message describing why the node is being shutdown.
  # @type  msg: str
  # @return: [code, msg, 0]
  # @rtype: [int, str, int]
  server.on 'shutdown', (err, params, callback) ->
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

  # Unregister the caller as a publisher of the topic.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param topic: Fully-qualified name of topic to unregister.
  # @type  topic: str
  # @param caller_api str: API URI of service to
  # unregister. Unregistration will only occur if current
  # registration matches.
  # @type  caller_api: str
  # @return: (code, statusMessage, numUnregistered).
  # If numUnregistered is zero it means that the caller was not registered as a publisher.
  # The call still succeeds as the intended final state is reached.
  # @rtype: (int, str, int)
  server.on 'unregisterPublisher', (err, params, callback) ->
    callback null, [1, "success", params]

  # Unregister the caller as a provider of the specified service.
  # @param caller_id str: ROS caller id
  # @type  caller_id: str
  # @param service: Fully-qualified name of service
  # @type  service: str
  # @param service_api: API URI of service to unregister. Unregistration will only occur if current
  # registration matches.
  # @type  service_api: str
  # @return: (code, message, numUnregistered). Number of unregistrations (either 0 or 1).
  # If this is zero it means that the caller was not registered as a service provider.
  # The call still succeeds as the intended final state is reached.
  # @rtype: (int, str, int)
  server.on 'unregisterService', (err, params, callback) ->
    callback null, [1, "success", params]

  # Unregister the caller as a publisher of the topic.
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param topic: Fully-qualified name of topic to unregister.
  # @type  topic: str
  # @param caller_api: API URI of service to unregister. Unregistration will only occur if current
  # registration matches.
  # @type  caller_api: str
  # @return: (code, statusMessage, numUnsubscribed).
  # If numUnsubscribed is zero it means that the caller was not registered as a subscriber.
  # The call still succeeds as the intended final state is reached.
  # @rtype: (int, str, int)
  server.on 'unregisterSubscriber', (err, params, callback) ->
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

