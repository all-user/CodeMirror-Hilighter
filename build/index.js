(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
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



},{"./add-css":2,"./evaluable-annotation":3,"extend":4}],2:[function(require,module,exports){
var addCSS;

addCSS = function(rule) {
  var styleEle;
  styleEle = document.createElement('style');
  document.head.appendChild(styleEle);
  return styleEle.sheet.insertRule(rule, 0);
};

module.exports = addCSS;



},{}],3:[function(require,module,exports){
var EvaluableAnnotation, addCSS, evalAnnotations, extend, getAnnotations, getElements, hideAnnotations;

extend = require('extend');

addCSS = require('./add-css');

hideAnnotations = function(qs) {
  return addCSS(qs + " {\n  width     : 0;\n  height    : 0;\n  visibility:hidden;\n}");
};

evalAnnotations = function(qs, elmSlector) {
  var annotations;
  annotations = document.querySelectorAll(qs);
  return [].map.call(annotations, function(annot) {
    var data, elm;
    elm = elmSlector(annot);
    data = eval("(" + (annot.getAttribute('data-eval')) + ")");
    return {
      ref: annot,
      elm: elm,
      data: data
    };
  });
};

getAnnotations = function(qs) {
  return evalAnnotations(qs, function(annot) {
    var elm;
    elm = annot.nextSibling;
    while ((elm != null ? elm.nodeType : void 0) === Node.TEXT_NODE) {
      elm = elm.nextSibling;
    }
    return elm;
  });
};

getElements = function(qs) {
  return evalAnnotations(qs, function(annot) {
    return annot;
  });
};

EvaluableAnnotation = {
  getAnnotations: getAnnotations,
  getElements: getElements
};

module.exports = EvaluableAnnotation;



},{"./add-css":2,"extend":4}],4:[function(require,module,exports){
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
