module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    mochacli:
      options:
        require: ['coffee-script/register']
        reporter: 'nyan'
        bail: true
      all: ['test/*.coffee']

  grunt.loadNpmTasks 'grunt-mocha-cli'

  grunt.registerTask 'version', () ->
    grunt.log.writeln "goblin #{grunt.config.get 'pkg.version'}"

  grunt.registerTask 'test', 'mochacli'
  grunt.registerTask 'default', 'version'
