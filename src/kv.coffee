# KV Storage Helpers
_ = require 'underscore'
SEP = '/'

isTree = (x) -> _.isObject x # and (not _.isArray x) and (not _.isFunction x)

mergeTree = (lhs, rhs) ->
  mergeTree_ (_.extend {}, lhs), rhs

mergeTree_ = (lhs, rhs) ->
  for key, value of rhs
    if lhs[key] is undefined
      lhs[key] = value
    else
      lhs[key] = mergeTree_ lhs[key], value
  return lhs

kvTree = (result) ->
  xs = result.Key.split SEP
  tree = "#{xs.pop()}": JSON.parse result.Value
  for ns in xs.reverse()
    tree = "#{ns}": tree
  return tree

parseQuery = (query) ->
  trees = (kvTree node for node in query)
  _.foldl trees, mergeTree

expandTree = (root, node) ->
  if not isTree node
    [{Key: root, Value: JSON.stringify node}]
  else
    _.foldl (expandTree "#{root}/#{key}", value for key, value of node),
            (lhs, rhs) -> lhs.concat rhs

exports.parseQuery = parseQuery
exports.mergeTree = mergeTree
exports.kvTree = kvTree
exports.expandTree = expandTree
