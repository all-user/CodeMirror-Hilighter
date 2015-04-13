RoomMirror = require '../../lib'

# mode files request generatior
# modePath = '../../node_modules/codemirror/mode/'
# modeList = [
#   'htmlmixed'
#   'css'
#   'javascript'
#   'coffeescript'
#   'ruby'
# ]
# console.log "require '#{ modePath }#{ mode }/#{ mode }'" for mode in modeList

require '../../node_modules/codemirror/mode/htmlmixed/htmlmixed'
require '../../node_modules/codemirror/mode/css/css'
require '../../node_modules/codemirror/mode/javascript/javascript'
require '../../node_modules/codemirror/mode/coffeescript/coffeescript'
require '../../node_modules/codemirror/mode/ruby/ruby'

# default settings to hilight
#   {
#     viewportMargin: Infinity,
#     readOnly      : true
#   }
#
# RoomMirror.preset merge more settings.
RoomMirror.preset = theme: 'monokai'

document.addEventListener 'DOMContentLoaded', ->
  window.rmA = RoomMirror.byAnnotation '.rm-cfg'
  window.rmE = RoomMirror '.rm-elm'

