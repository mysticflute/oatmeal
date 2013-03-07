# oatmeal
# https://github.com/endium/oatmeal
#
# Copyright (c) 2013 Nathan McWilliams
# Licensed under the MIT license.
#
# Learn more about grunt: http://gruntjs.com/getting-started
#
# For developement the following commands are useful
#
# - `grunt test` (run the tests)
# - `grunt build` (compile the files)

'use strict'

module.exports = (grunt) ->

  # configuration
  grunt.initConfig

    #-------------------
    # grunt `clean` task
    # ------------------
    clean:
      dist: ['dist']

    #--------------------
    # grunt `coffee` task
    # -------------------
    coffee:
      compile:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'dist'
        ext: '.js'

    #-------------------
    # grunt `watch` task
    # ------------------
    watch:
      build:
        files: 'src/**/*.coffee'
        tasks: 'build'

    #--------------------
    # grunt `uglify` task
    # -------------------
    uglify:
      options:
        preserveComments: 'some'
      all:
        files:
          'dist/oatmeal.min.js': ['dist/oatmeal.js']


  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-notify'

  # aliases
  grunt.registerTask 'build', 'Compile the scripts', ['clean', 'coffee', 'uglify']
  grunt.registerTask 'test', 'Run the tests', ['build', 'nodeunit']

  # default task
  grunt.registerTask 'default', 'Does a full clean and build', ['test']