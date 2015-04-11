assert = require 'power-assert'
RoomMirror = require '../lib'
require "../node_modules/codemirror/mode/javascript/javascript.js"
require "../node_modules/codemirror/mode/coffeescript/coffeescript.js"
require "../node_modules/codemirror/mode/ruby/ruby.js"
require "../node_modules/codemirror/mode/css/css.js"
require "../node_modules/codemirror/mode/htmlmixed/htmlmixed.js"
require "../node_modules/codemirror/mode/markdown/markdown.js"
require "../node_modules/codemirror/mode/gfm/gfm.js"
# lngs = [
#   'javascript'
#   'coffeescript'
#   'ruby'
#   'css'
#   'htmlmixed'
#   'markdown'
#   'gfm'
# ]
# for lng in lngs
#   console.log "require \"../node_modules/codemirror/mode/#{ lng }/#{ lng }.js\""

describe 'RoomMirror test', ->

  div = document.createElement 'div'
  div.classList.add 'test-div'

  link = document.createElement 'link'
  cmstyle = link.cloneNode()
  cmstyle.setAttribute 'rel', 'stylesheet'
  cmstyle.setAttribute 'href', '../node_modules/codemirror/lib/codemirror.css'

  monokai = document.createElement 'link'
  monokai.setAttribute 'rel', 'stylesheet'
  monokai.setAttribute 'href', '../node_modules/codemirror/theme/monokai.css'

  script = document.createElement 'script'

  codeBlock = document.createElement 'div'
  annotation = document.createElement 'p'

  RoomMirror.preset =
    theme: 'monokai'

  beforeEach 'reset', (done) ->
    div.innerHTML = ''
    annotation.setAttribute 'data-eval', ''
    annotation.className = ''
    codeBlock.textContent = ''
    codeBlock.className = ''
    done()

  describe 'init', ->
    it 'init', (done) ->
      document.head.appendChild cmstyle
      document.head.appendChild monokai
      document.body.appendChild div
      setTimeout ->
        done()
      , 100


  describe 'mode test', ->

    it 'mode javascript', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        var test = 'test';
        var array = [0, 1, 2];

        var add = function(a, b) {
          return a + b;
        }

        var result = array.reduce(add, 0);
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'javascript'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'javascript'
        done()
      , 50


    it 'mode ruby', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        test = 'test'
        array = [0, 1, 2]

        def add(*b)
          b.reduce 0, :+
        end

        array.map{ |i| i**2 }.each do |i|
          p i
        end
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'ruby'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'ruby'
        done()
      , 50


    it 'mode coffeescript', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        test = 'test'
        array = [0, 1, 2]

        add = (b...) ->
          b.reduce (acc, n) ->
            acc + n
          , 0

        add 12, 49, 222, 409

        for i in array.map((n) -> n * n)
          console.log i
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'coffeescript'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'coffeescript'
        done()
      , 50

    it 'mode css', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        .test {
          width: 50%;
          height: auto;
          border: 2px solid #889;
          display: block;
          position: relative;
        }

        #content .lint > a {
          float: left;
          border-radius: 50%;
          z-index: 200;
        }

        #content .lint > a:before {
          content: '.'
          width: 0;
          height: 0;
          visibility: hidden;
          clear: both;
        }
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'css'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'css'
        done()
      , 50


    it 'mode htmlmixed', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        <!doctype html>
        <html>
        <head>
          <style>
            .test {
              width: 50%;
              height: auto;
              border: 2px solid #889;
              display: block;
              position: relative;
            }

            #content .lint > a {
              float: left;
              border-radius: 50%;
              z-index: 200;
            }

            #content .lint > a:before {
              content: '.'
              width: 0;
              height: 0;
              visibility: hidden;
              clear: both;
            }
          </style>
          <script>
            var test = 'test';
            var array = [0, 1, 2];

            var add = function(a, b) {
              return a + b;
            }

            var result = array.reduce(add, 0);
          </script>
        </head>
        <body>
          <div id="wrapper" class="test">
            <h1 class="title">mode test</h1>
            <p class="description">test description</p>
          </div>
        </body>
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'htmlmixed'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'htmlmixed'
        done()
      , 50


    it 'mode markdown', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        # test title

        ## test topic


        - test list
          + style
            - first
            - second

        * width
        * height
          * border
          * display
          * position
            * width
            * height
            * border
            * display
            * position

        [Google](http://google/com/)
        ![test](http://path/to/image.pmg "img title")

        _emphasis_, __strong__
        test string

        ### code block

            var test = 'test';
            var array = [0, 1, 2];

            var add = function(a, b) {
              return a + b;
            }

            var result = array.reduce(add, 0);
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'markdown'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'markdown'
        done()
      , 50


    it 'mode gfm', (done) ->

      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        # test title

        ## test topic


        - test list
          + style
            - first
            - second

        * width
        * height
          * border
          * display
          * position
            * width
            * height
            * border
            * display
            * position

        [Google](http://google/com/)
        ![test](http://path/to/image.pmg "img title")

        _emphasis_, __strong__
        test string

        ### code block

            var test = 'test';
            var array = [0, 1, 2];

            var add = function(a, b) {
              return a + b;
            }

            var result = array.reduce(add, 0);

        ```javascript
        var test = 'test';
        var array = [0, 1, 2];

        var add = function(a, b) {
          return a + b;
        }

        var result = array.reduce(add, 0);
        ```
        '''
      codeBlock.setAttribute('data-eval',
        '''
        {
          mode: 'gfm'
        }
        '''
      )
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].doc.mode?
        assert rm[0].doc.mode.name is 'gfm'
        done()
      , 50


  describe 'option test', ->

    it 'editable', (done) ->
      div.appendChild codeBlock
      codeBlock.textContent = 'test whether editable'
      codeBlock.setAttribute 'data-eval', '{ readOnly: false }'
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].getOption('readOnly') is false
        done()
      , 50


    it 'line wrapping, line numbers', (done) ->
      div.appendChild codeBlock
      codeBlock.textContent = 'test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping test line wrapping'
      codeBlock.setAttribute 'data-eval', '{ lineWrapping: true, lineNumbers: true }'
      codeBlock.classList.add 'rm', 'codeblock'

      rm = RoomMirror '.rm'

      setTimeout ->
        assert rm[0].getOption('lineWrapping') is true
        assert rm[0].getOption('lineNumbers') is true
        done()
      , 50


  describe 'by annotation test', ->

    it 'p tag annotation', (done) ->
      div.appendChild annotation
      div.appendChild codeBlock
      codeBlock.textContent =
        '''
        def gen_square
          return to_enum :gen_square unless block_given?
          (2...Float::INFINITY).each do |i|
            yield i**2
          end
        end

        enum = gen_square
        enum.next
        '''
      annotation.setAttribute 'data-eval', '{ mode: "ruby", lineNumbers: true }'
      annotation.classList.add 'rm-a'

      rm = RoomMirror.byAnnotation '.rm-a'

      setTimeout ->
        assert rm[0].doc.mode.name is 'ruby'
        assert rm[0].getOption('lineNumbers') is true
        done()
      , 50
