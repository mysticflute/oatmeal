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
      specs: ['spec/build']

    #--------------------
    # grunt `coffee` task
    # -------------------
    coffee:
      sources:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'dist'
        ext: '.js'
      specs:
        expand: true
        cwd: 'spec'
        src: '*.coffee'
        dest: 'spec/build'
        ext: '.js'

    #-------------------
    # grunt `watch` task
    # ------------------
    watch:
      build:
        files: ['src/**/*.coffee', 'spec/**/*.coffee']
        tasks: 'qtest'

    #--------------------
    # grunt `uglify` task
    # -------------------
    uglify:
      options:
        preserveComments: 'some'
      all:
        files:
          'dist/oatmeal.min.js': ['dist/oatmeal.js']

    #---------------------
    # grunt `jasmine` task
    # --------------------
    jasmine:
      all:
        src: 'dist/oatmeal.js'
        options:
          specs: 'spec/build/**/*.js'

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-notify'

  # aliases
  grunt.registerTask 'build', 'Compile the scripts', ['clean', 'coffee', 'uglify']
  grunt.registerTask 'test', 'Build and run the tests', ['build', 'jasmine']
  grunt.registerTask 'qtest', 'A quicker version of test', ['coffee', 'jasmine']
  grunt.registerTask 'dev', 'For development, watch for changes and rebuild + test automatically', ['watch']

  # default task
  grunt.registerTask 'default', 'Build and run the tests', ['test']


