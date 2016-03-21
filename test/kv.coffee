(require 'chai').should()
_ = require 'underscore'
kv = require '../src/kv.coffee'

describe 'KV Helpers', () ->
  describe 'mergeTree', () ->
    lhs =
      root:
        child_l: 42
      value: 'lhs'
    rhs =
      root:
        child_r: 'foo'
        value: 'rhs'
    merged =
      root:
        child_l: 42
        child_r: 'foo'
        value: 'rhs'
      value: 'lhs'
    lhs_ = _.extend {}, lhs
    rhs_ = _.extend {}, rhs
    it 'should recursively merge tree nodes (objects)', () ->
      (kv.mergeTree lhs_, rhs_).should.eql merged
    it 'should works functionally', () ->
      lhs_.should.eql lhs
      rhs_.should.eql rhs
    it "should works on 'empty objects' ({})", () ->
      (kv.mergeTree {}, {}).should.eql {}
    it "should satisfy: mergeTree({}, tree) === tree", () ->
      (kv.mergeTree {}, lhs).should.eql lhs

  describe 'kvTree', () ->
    it 'should build trees correctly', () ->
      node = {Key: 'foo/bar/baz', Value: 42}
      tree = foo:
        bar:
          baz: 42
      (kv.kvTree node).should.eql tree
    it 'should build simple object when no namespace found', () ->
      node = {Key: 'foobar', Value: 42}
      tree = foobar: 42
      (kv.kvTree node).should.eql tree

  describe 'parseQuery', () ->
    it 'should build a tree whose root namespace is exactly the key used in getParam', () ->
      query = [
        {Key: 'foo/bar', Value: 42}
        {Key: 'foo/baz', Value: true}
        {Key: 'foo/abc/mno', Value: 'xyz'}
      ]
      parsed =
        foo:
          bar: 42
          baz: true
          abc:
            mno: 'xyz'
      (kv.parseQuery query).should.eql parsed

