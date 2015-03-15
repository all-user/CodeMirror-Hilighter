(function() {
  var RoomMirror, addCSS, byAnnotations, defaultConfig, evalAnnot, extend, hilight;

  evalAnnot = require('./evaluable-annotation');

  addCSS = require('./add-css');

  extend = require('extend');

  defaultConfig = {
    viewportMargin: Infinity,
    readOnly: true
  };

  addCSS(".RoomMirror {\n  height: auto;\n}");

  hilight = function(annot) {
    var config;
    config = extend({}, defaultConfig, this.preset, annot.data, {
      value: annot.elm.textContent
    });
    return CodeMirror(function(editor) {
      editor.classList.add('RoomMirror');
      return annot.elm.parentNode.replaceChild(editor, annot.elm);
    }, config);
  };

  byAnnotations = function(qs) {
    var annot, annotations, i, len;
    annotations = evalAnnot.getAnnotations(qs);
    for (i = 0, len = annotations.length; i < len; i++) {
      annot = annotations[i];
      annot.ref.remove();
      if (!annot.elm) {
        return;
      }
      (hilight.bind(this))(annot);
    }
  };


  /**
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
   */

  RoomMirror = function(qs) {
    var annot, annotations, i, len, results;
    annotations = evalAnnot.getElements(qs).map(function(annot) {
      annot.elm = annot.ref;
      return annot;
    });
    results = [];
    for (i = 0, len = annotations.length; i < len; i++) {
      annot = annotations[i];
      results.push((hilight.bind(RoomMirror))(annot));
    }
    return results;
  };

  extend(RoomMirror, {

    /**
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
     */
    preset: {},

    /**
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
     */
    byAnnotations: byAnnotations
  });

  module.exports = RoomMirror;

}).call(this);
