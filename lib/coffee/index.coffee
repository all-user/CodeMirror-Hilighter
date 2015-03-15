evalAnnot = require './evaluable-annotation'
addCSS = require './add-css'
extend = require 'extend'

defaultConfig =
  viewportMargin: Infinity
  readOnly      : true

addCSS """
  .RoomMirror {
    height: auto;
  }
"""

hilight = (annot) ->
  config = extend(
    {},
    defaultConfig,
    @preset,
    annot.data,
    value: annot.elm.textContent)
  CodeMirror (editor) ->
    editor.classList.add 'RoomMirror'
    annot.elm.parentNode.replaceChild editor, annot.elm
  , config

byAnnotations = (qs) ->
  annotations = evalAnnot.getAnnotations qs
  for annot in annotations
    annot.ref.remove()
    return unless annot.elm
    (hilight.bind @) annot


###*
* @class RoomMirror
* HTML内の任意の要素をコードブロックとして、`CodeMirror`を使用したシンタックスハイライトを行う<br>
* `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される
*
*     <pre class="rm-elm" data-eval="{ mode:'javascript' }"><code>
*     var test = 'test';
*     </code></pre>
*
*     <script>
*         var codeBlocks = RoomMirror('.rm-elm');
*     </script>
*
* @param {String} qs  String for querySelector
* @return {CodeMirror}
###
RoomMirror = (qs) ->
  annotations = evalAnnot.getElements qs
    .map (annot) ->
      annot.elm = annot.ref
      annot
  for annot in annotations
    (hilight.bind RoomMirror) annot


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
  * HTML内の任意の要素を、次に続く要素のアノテーションとみなしてシンタックスハイライトを行う<br>
  * `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される
  *
  *     <p class="rm-cfg" data-eval="{ mode:'javascript' }"></p>
  *     <pre><code>
  *     var test = 'test';
  *     </code></pre>
  *
  *     <script>
  *         var codeBlocks = RoomMirror.byAnnotations('.rm-cfg');
  *     </script>
  *
  * @param {String} qs  String for querySelector
  * @return {CodeMirror}
  ###
  byAnnotations: byAnnotations

module.exports = RoomMirror
