window.CodeMirror ?= require 'codemirror'
ET         = require 'evaluable-tag'
appendCSS  = require 'append-css'
extend     = require 'extend'


defaultConfig =
  viewportMargin: Infinity
  readOnly      : true

appendCSS """
  .RoomMirror {
    height: auto;
  }
"""

hilight = (et) ->
  config = extend(
    {},
    defaultConfig,
    @preset,
    et.result,
    value: et.annotated.textContent)
  CodeMirror (editor) ->
    editor.classList.add 'RoomMirror'
    et.annotated.parentNode.replaceChild editor, et.annotated
  , config

byAnnotations = (qs) ->
  evaluated = ET.evalAnnotationsBy qs
  for et in evaluated
    return unless et.annotated
    (hilight.bind @) et


###*
* @class RoomMirror
* HTML内の任意の要素に`CodeMirror`を使用したシンタックスハイライトを行う<br>
* `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される
*
*     <pre class="rm" data-eval="{ mode:'javascript' }"><code>
*     var test = 'test';
*     </code></pre>
*
*     <script>
*         var codeBlocks = RoomMirror('.rm');
*     </script>
*
* @param {String} qs  String for querySelector
* @return {CodeMirror}
###
RoomMirror = (qs) ->
  evaluated = ET.evalBy qs
  for et in evaluated
    (hilight.bind RoomMirror) et


extend RoomMirror,
  ###*
  * @cfg {Object} preset
  * コードブロックの共通の設定を指定する<br>
  * デフォルトの設定とマージされた後`CodeMirror`に渡される<br>
  *
  *     var defaultConfig = {
  *         readOnly      : true,
  *         viewportMargin: Infinity
  *     };
  *
  * シンタックスハイライトとして使う場合はカラースキームの指定程度で大丈夫<br>
  * 下に挙げる幾つかのオブション以外はCodeMirror`の[**Configuration**](http://codemirror.net/doc/manual.html#config)を参照
  * @cfg {Boolean} [preset.readOnly=true]
  * コードブロックを編集可能にしたい場合は`false`に指定
  * @cfg {Number} [preset.viewportMargin=Infinity]
  * コードブロックの高さを行数で指定する<br>
  * この値を`Infinity`に設定し、CSSで`.RoomMirror { height: auto; }`を指定すると<br>
  * コードブロックの内容に応じて行数が調整される<br>
  * デフォルトではこの設定になっている
  ###
  preset: {}
  ###*
  * @method byAnnotations
  * HTML内の任意の要素をアノテーションとみなして、次に続く要素のシンタックスハイライトを行う<br>
  * `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される
  *
  *     <p class="rm-a" data-eval="{ mode:'javascript' }"></p>
  *     <pre><code>
  *     var test = 'test';
  *     </code></pre>
  *
  *     <script>
  *         var codeBlocks = RoomMirror.byAnnotations('.rm-a');
  *     </script>
  *
  * @param {String} qs  String for querySelector
  * @return {CodeMirror}
  ###
  byAnnotations: byAnnotations


module.exports = RoomMirror
