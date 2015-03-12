gulp = require 'gulp'
gutil = require 'gulp-util'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
watchify = require 'watchify'
# merge = (require 'event-stream').merge
# shell = require 'gulp-shell'

gulp.task 'browserify', ['paraout'], ->
  browserify
    entries : ['./src/coffee/app.coffee']
    extensions : ['.coffee']
  .bundle()
  .pipe source 'app.js'
  .pipe gulp.dest './build/'

gulp.task 'watch', ->
  bundler =
    watchify
      entries : ['./src/coffee/app.coffee']
      extensions : ['.coffee']
      verbose : on
  rebundle = ->
    bundler.bundle()
    .on 'error', (e) ->
      gutil.log 'Browserify Error', e
    .pipe source 'app.js'
    .pipe gulp.dest './build/'
  bundler.on 'update', rebundle
  rebundle()

gulp.task 'lint', ->
  gulp.src ['./src/coffee/**/*.coffee', './src/coffee/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()


gulp.task 'paraout', ->
  gulp.src "./src/coffee/**/*.coffee"
    .pipe coffee()
    .pipe gulp.dest "./src/js/"


# gulp.task 'build_test_case', ->
#   tests = []

#   tasks = tests.map (testName) ->
#     browserify
#       entries : ["./src/coffee/test/#{ testName }.coffee"]
#       extensions : ['.coffee']
#     .bundle()
#     .pipe source 'test.js'
#     .pipe gulp.dest "./test/#{ testName }/"

#   merge tasks...

gulp.task 'default', ['lint', 'browserify']
