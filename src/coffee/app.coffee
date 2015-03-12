CodeMirrror = require 'codemirror'

# mode files
modePath = '../../node_modules/codemirror/mode/'
require modePath + 'htmlmixed/htmlmixed'
require modePath + 'css/css'
require modePath + 'javascript/javascript'
require modePath + 'coffeescript/coffeescript'
require modePath + 'ruby/ruby'

document.addEventListener 'DOMContentLoaded', ->
