# RoomMirror
Syntax highlight code blocks generated from Markdown with CodeMirror.

## doc in japanese

[RoomMirror Doc: 日本語ドキュメント](http://all-user.github.io/roommirror/docs)

## install
```bash
npm install roommirror
```

## usage

### common settings
path to `codemirror` is `"roommirror_root/node_modules/codemirror"`
```html
<link rel="stylesheet" href="codemirror/lib/codemirror.css">
```
and theme files...
```html
<link rel="stylesheet" href="codemirror/theme/base16-dark.css">
<link rel="stylesheet" href="codemirror/theme/solarized.css">
<link rel="stylesheet" href="codemirror/theme/monokai.css">
```

### in browser
```html
<script src="browser/roommirror.js"></script>
```

or __exclude CodeMirror__...
```html
<script src="path/to/codemirror.js"></script>
<script src="browser/rm_without_cm.js"></script>
```

and __mode files...__
```html
<script src="codemirror/mode/htmlmixed/htmlmixed.js"></script>
<script src="codemirror/mode/javascript/javascript.js"></script>
<script src="codemirror/mode/css/css.js"></script>
```

### in browserify
```javascript
var RoomMirror = require('roommirror');

// and mode files...
require('codemirror/mode/htmlmixed/htmlmixed.js');
require('codemirror/mode/javascript/javascript.js');
require('codemirror/mode/css/css.js');
```

## RoomMirror(qs) -> [CodeMirror]

- parameter<br>
  __qs__: css selector of elements you want syntax highlighting.
- return<br>
  __[CodeMirror]__: array of codemirror instances that highlighted code blocks.

## RoomMirror.byAnnotation(qs) -> [CodeMirror]

- parameter<br>
  __qs__: css selector of previous elements you want syntax highlighting.
```html
<p class="rm-a" data-eval="{ mode: 'javascript' }"></p>
<div>var test = 'test';</div>
```
- return<br>
  __[CodeMirror]__: array of codemirror instances that highlighted code blocks.

## example for markdown
in markdown...
```markdown
<p class="rm-a" data-eval="{ mode: 'javascript', lineNumbers: true }"></p>

    var test = 'test';
    var add = function(a, b) {
      return a + b;
    };

    [0, 1, 2, 3, 4].reduce(add, 0); // 10

```

generate to html...

```html
<p class="rm-a" data-eval="{ mode: 'javascript', lineNumbers: true }"></p>
<pre><code>var test = 'test';
var add = function(a, b) {
  return a + b;
};

[0, 1, 2, 3, 4].reduce(add, 0); // 10</code></pre>
```

syntax highlighting

```javascript
var roommirrors = RoomMirror.byAnnotation('.rm-a');
```

##demo

in myblog: [メモを揉め](http://memowomome.hatenablog.com/entry/2015/04/18/145610)
