(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  window.RoomMirror = require('./index.js');

}).call(this);

},{"./index.js":2}],2:[function(require,module,exports){
(function() {
  var ET, RoomMirror, appendCSS, byAnnotation, defaultConfig, extend, hilight;

  if (window.CodeMirror == null) {
    window.CodeMirror = require('codemirror');
  }

  ET = require('evaluable-tag');

  appendCSS = require('append-css');

  extend = require('extend');

  defaultConfig = {
    viewportMargin: Infinity,
    readOnly: true
  };

  appendCSS(".RoomMirror {\n  height: auto;\n}");

  hilight = function(et) {
    var config;
    config = extend({}, defaultConfig, this.preset, et.result, {
      value: et.annotated.textContent
    });
    return CodeMirror(function(editor) {
      editor.classList.add('RoomMirror');
      return et.annotated.parentNode.replaceChild(editor, et.annotated);
    }, config);
  };

  byAnnotation = function(qs) {
    var et, evaluated, i, len, results;
    evaluated = ET.evalAnnotationsBy(qs);
    results = [];
    for (i = 0, len = evaluated.length; i < len; i++) {
      et = evaluated[i];
      if (et.annotated != null) {
        results.push((hilight.bind(this))(et));
      } else {
        results.push(null);
      }
    }
    return results;
  };


  /**
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
  * @return {[CodeMirror]}
   */

  RoomMirror = function(qs) {
    var et, evaluated, i, len, results;
    evaluated = ET.evalBy(qs);
    results = [];
    for (i = 0, len = evaluated.length; i < len; i++) {
      et = evaluated[i];
      results.push((hilight.bind(RoomMirror))(et));
    }
    return results;
  };

  extend(RoomMirror, {

    /**
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
     */
    preset: {},

    /**
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
    * @return {[CodeMirror]}
     */
    byAnnotation: byAnnotation
  });

  module.exports = RoomMirror;

}).call(this);

},{"append-css":3,"codemirror":undefined,"evaluable-tag":5,"extend":7}],3:[function(require,module,exports){
var m = require('./lib');
module.exports = m;

},{"./lib":4}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.9.1
(function() {
  var _init, appendCSS, styleEle;

  styleEle = null;

  _init = function() {
    styleEle = document.createElement('style');
    return document.head.appendChild(styleEle);
  };

  appendCSS = function(rule) {
    var sheet;
    sheet = styleEle.sheet;
    sheet.insertRule(rule, sheet.cssRules.length);
    return styleEle;
  };

  appendCSS.reset = function() {
    document.head.removeChild(styleEle);
    return _init();
  };

  _init();

  module.exports = appendCSS;

}).call(this);

},{}],5:[function(require,module,exports){
arguments[4][3][0].apply(exports,arguments)
},{"./lib":6,"dup":3}],6:[function(require,module,exports){
// Generated by CoffeeScript 1.9.1
(function() {
  var EvaluableTag, _eval, _hide, appendCSS, evalAnnotationsBy, evalBy, extend, hidQueries;

  extend = require('extend');

  appendCSS = require('append-css');

  hidQueries = [];

  _hide = function(qs) {
    return appendCSS(qs + " {\n  width      : 0;\n  height     : 0;\n  line-height: 0;\n  visibility : hidden;\n}");
  };

  _eval = function(qs, select) {
    var tags;
    tags = document.querySelectorAll(qs);
    return [].map.call(tags, function(tag) {
      var res, target;
      target = select(tag);
      res = eval("(" + (tag.getAttribute('data-eval')) + ")");
      return {
        annotation: tag,
        annotated: target,
        result: res
      };
    });
  };

  evalAnnotationsBy = function(qs) {
    if (hidQueries.indexOf(qs) === -1) {
      hidQueries.push(qs);
      _hide(qs);
    }
    return _eval(qs, function(tag) {
      var target;
      target = tag.nextSibling;
      while ((target != null ? target.nodeType : void 0) === Node.TEXT_NODE) {
        target = target.nextSibling;
      }
      return target;
    });
  };

  evalBy = function(qs) {
    return _eval(qs, function(tag) {
      return tag;
    });
  };

  EvaluableTag = {
    evalAnnotationsBy: evalAnnotationsBy,
    evalBy: evalBy
  };

  module.exports = EvaluableTag;

}).call(this);

},{"append-css":3,"extend":7}],7:[function(require,module,exports){
var hasOwn = Object.prototype.hasOwnProperty;
var toString = Object.prototype.toString;
var undefined;

var isPlainObject = function isPlainObject(obj) {
	'use strict';
	if (!obj || toString.call(obj) !== '[object Object]') {
		return false;
	}

	var has_own_constructor = hasOwn.call(obj, 'constructor');
	var has_is_property_of_method = obj.constructor && obj.constructor.prototype && hasOwn.call(obj.constructor.prototype, 'isPrototypeOf');
	// Not own constructor property must be Object
	if (obj.constructor && !has_own_constructor && !has_is_property_of_method) {
		return false;
	}

	// Own properties are enumerated firstly, so to speed up,
	// if last one is own, then all properties are own.
	var key;
	for (key in obj) {}

	return key === undefined || hasOwn.call(obj, key);
};

module.exports = function extend() {
	'use strict';
	var options, name, src, copy, copyIsArray, clone,
		target = arguments[0],
		i = 1,
		length = arguments.length,
		deep = false;

	// Handle a deep copy situation
	if (typeof target === 'boolean') {
		deep = target;
		target = arguments[1] || {};
		// skip the boolean and the target
		i = 2;
	} else if ((typeof target !== 'object' && typeof target !== 'function') || target == null) {
		target = {};
	}

	for (; i < length; ++i) {
		options = arguments[i];
		// Only deal with non-null/undefined values
		if (options != null) {
			// Extend the base object
			for (name in options) {
				src = target[name];
				copy = options[name];

				// Prevent never-ending loop
				if (target === copy) {
					continue;
				}

				// Recurse if we're merging plain objects or arrays
				if (deep && copy && (isPlainObject(copy) || (copyIsArray = Array.isArray(copy)))) {
					if (copyIsArray) {
						copyIsArray = false;
						clone = src && Array.isArray(src) ? src : [];
					} else {
						clone = src && isPlainObject(src) ? src : {};
					}

					// Never move original objects, clone them
					target[name] = extend(deep, clone, copy);

				// Don't bring in undefined values
				} else if (copy !== undefined) {
					target[name] = copy;
				}
			}
		}
	}

	// Return the modified object
	return target;
};


},{}]},{},[1]);
