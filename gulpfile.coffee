gulp = require 'gulp'
gutil = require 'gulp-util'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
watchify = require 'watchify'
merge = (require 'event-stream').merge
shell = require 'gulp-shell'

gulp.task 'browserify', ->
  browserify
    entries : ['./lib/coffee/index.coffee']
    extensions : ['.coffee']
  .bundle()
  .pipe source 'index.js'
  .pipe gulp.dest './build/'

gulp.task 'watch', ->
  bundler =
    watchify
      entries : ['./lib/coffee/index.coffee']
      extensions : ['.coffee']
      verbose : on
  rebundle = ->
    bundler.bundle()
    .on 'error', (e) ->
      gutil.log 'Browserify Error', e
    .pipe source 'index.js'
    .pipe gulp.dest './build/'
  bundler.on 'update', rebundle
  rebundle()

gulp.task 'lint', ->
  gulp.src ['./lib/coffee/**/*.coffee', './lib/coffee/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()


gulp.task 'paraout', ->
  gulp.src './lib/coffee/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest './lib/js/'


gulp.task 'example', ->
  examples = ['Markdown']
  tasks = examples.map (exampleName) ->
    browserify
      entries : ["./example/#{ exampleName }/index.coffee"]
      extensions : ['.coffee']
    .bundle()
    .pipe source 'index.js'
    .pipe gulp.dest "./example/#{ exampleName }"
  merge tasks...

gulp.task 'test', ->
  browserify
    entries: ['./test/tests.coffee']
    extensions: ['.coffee']
  .bundle()
  .pipe source 'tests.js'
  .pipe gulp.dest './test/build'

gulp.task 'jsduck', ['paraout'], shell.task ['jsduck -o ./docs --config=jsduck.json']

gulp.task 'default', ['lint', 'browserify', 'jsduck', 'example', 'test']
