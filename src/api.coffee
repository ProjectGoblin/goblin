injectMasterAPI = require './master_api.coffee'
injectParamAPI = require './param_api.coffee'

exports.injectMasterAPI = injectMasterAPI
exports.injectParamAPI = injectParamAPI
exports.injectAPI = (server) ->
  injectMasterAPI server
  injectParamAPI server
