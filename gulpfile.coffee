gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
coffeeify = require 'coffeeify'
merge = (require 'event-stream').merge
shell = require 'gulp-shell'

gulp.task 'lint', ->
  gulp.src ['./src/**/*.coffee', './example/**/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'coffee', ['lint'], ->
  gulp.src './src/**/*.coffee'
  .pipe coffee()
  .pipe gulp.dest './lib'

gulp.task 'browserify', ['coffee'], ->
  browserify()
  .add './lib/browser.js'
  .bundle()
  .pipe source 'build.js'
  .pipe gulp.dest './browser'

gulp.task 'others', ->
  gulp.watch './browser/build.js', ['exclude', 'example', 'jsduck']

gulp.task 'exclude', ->
  browserify()
  .add './lib/browser.js'
  .exclude 'codemirror'
  .bundle()
  .pipe source 'exclude_cm.js'
  .pipe gulp.dest './browser'

gulp.task 'example', ->
  examples = ['Markdown']
  tasks = examples.map (exampleName) ->
    browserify
      entries : ["./example/#{ exampleName }/index.coffee"]
      extensions : ['.coffee']
    .transform coffeeify
    .bundle()
    .pipe source 'index.js'
    .pipe gulp.dest "./example/#{ exampleName }"
  merge tasks...

gulp.task 'jsduck', shell.task ['jsduck -o ./docs --config=jsduck.json']

gulp.task 'default', ['browserify']
