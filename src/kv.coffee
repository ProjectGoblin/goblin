# KV Storage Helpers
_ = require 'underscore'
SEP = '/'

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
  tree = "#{xs.pop()}": result.Value
  for ns in xs.reverse()
    tree = "#{ns}": tree
  return tree

parseQuery = (query) ->
  trees = (kvTree node for node in query)
  _.foldl trees, mergeTree

exports.parseQuery = parseQuery
exports.mergeTree = mergeTree
exports.kvTree = kvTree
