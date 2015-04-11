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

byAnnotation = (qs) ->
  evaluated = ET.evalAnnotationsBy qs
  for et in evaluated
    if et.annotated?
      (hilight.bind @) et
    else
      null


###*
* @class RoomMirror
* HTML内の任意の要素に`CodeMirror`を使用したシンタックスハイライトを行う<br>
* `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される<br>
*
* html
*
*     <pre class="rm" data-eval="{ mode:'javascript' }"><code>
*     var test = 'test';
*     </code></pre>
*
* javascript
*
*     var codeBlocks = RoomMirror('.rm');
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
  *     RoomMirror.preset = {
  *         mode : 'javascript',
  *         theme: 'monokai'
  *     };
  *
  *     // var defaultConfig = {
  *     //     readOnly      : true,
  *     //     viewportMargin: Infinity
  *     // };
  *
  * シンタックスハイライトとして使う場合は言語とカラースキームの指定程度で大丈夫<br>
  * 下に主なオブションを挙げる。他にも`CodeMirror`の[**Configuration**](http://codemirror.net/doc/manual.html#config)を参照
  * @cfg {Boolean} [preset.readOnly=true]
  * コードブロックを編集可能にしたい場合は`false`に指定<br>
  * `false`を指定することでエディタとして使うことも可能
  * @cfg {Number} [preset.viewportMargin=Infinity]
  * コードブロックの高さを行数で指定する<br>
  * この値を`Infinity`に設定し、CSSで`.RoomMirror { height: auto; }`を指定すると<br>
  * コードブロックの内容に応じて行数が調整される<br>
  * デフォルトではこの設定になっている
  * @cfg {Integer} [preset.tabSize=4]
  * タブのサイズを指定する
  * @cfg {Boolean} [preset.lineWrapping=false]
  * 一行が長い時、はみ出た部分のコードを折り返すかどうかを指定する<br>
  * デフォルトでは`false`に指定されており、はみ出た部分はスクロールで表示する
  * @cfg {Boolean} [preset.lineNumbers=false]
  * 左側に行番号を表示するかどうかを指定する
  * @cfg {Integer} [preset.firstLineNumber=1]
  * `lineNumbers`を`true`に設定した時、行番号がいくつから始まるかを指定する<br>
  * デフォルトでは`1`になっている
  * @cfg {(Integer) -> String} [preset.lineNumberFormatter]
  * `lineNumbers`を`true`に設定した時、行番号の表示フォーマットを指定する<br>
  * 行番号を表す整数を受け取り、整形した文字列を返す関数を指定する
  * @cfg {Boolean} [preset.fixedGutter=true]
  * `lineNumbers`、`lineWrapping`が`true`に設定され、水平スクロールが発生した時<br>
  * 行番号がスクロールに追従するかどうかを指定する<br>
  * デフォルトでは`true`に指定されており、コードブロックの左側に固定して表示される
  *
  ###
  preset: {}
  ###*
  * @method byAnnotation
  * HTML内の任意の要素をアノテーションとみなして、次に続く要素のシンタックスハイライトを行う<br>
  * `data-eval`の文字列がevalで評価され、デフォルトの設定とマージされた後`CodeMirror`に渡される<br>
  * Markdownのコードブロックをシンタックスハイライトする事を想定している<br>
  *
  * html
  *
  *     <p class="rm-a" data-eval="{ mode:'javascript' }"></p>
  *     <div>
  *     var test = 'test';
  *     </div>
  *
  * javascript
  *
  *     var codeBlocks = RoomMirror.byAnnotation('.rm-a');
  *
  * __Markdownの場合__
  *
  * markdown
  *
  *     <p class="rm-a" data-eval="{ mode:'javascript' }"></p>
  *     ```
  *     var code = 'code blocks in markdown.';
  *     ```
  *
  * javascript
  *
  *     var codeBlocks = RoomMirror.byAnnotation('.rm-a');
  *
  *
  * @param {String} qs  String for querySelector
  * @return {CodeMirror}
  ###
  byAnnotation: byAnnotation


module.exports = RoomMirror
