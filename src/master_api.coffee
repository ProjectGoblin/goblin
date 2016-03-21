_ = require 'underscore'
kv = require './kv.coffee'
async = require 'async'
consul = (require 'consul')()

module.exports = (server) ->
  # Master

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

  # Stop this server
  # @param caller_id: ROS caller id
  # @type  caller_id: str
  # @param msg: a message describing why the node is being shutdown.
  # @type  msg: str
  # @return: [code, msg, 0]
  # @rtype: [int, str, int]
  server.on 'shutdown', (err, params, callback) ->
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
