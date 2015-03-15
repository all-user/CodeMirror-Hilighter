# RoomMirror with Markdown
<p class="rm-cfg" data-eval="{
  mode        : 'javascript',
  lineNumbers : true,
  lineWrapping: true
}"></p>
    var test = "A long long ......................................................................................................................................................................................long string.";

    console.log(test);

<p class="rm-cfg" data-eval="{
  mode        : 'javascript',
  lineNumbers : true,
  lineWrapping: false
}"></p>
    var test = "A long long ......................................................................................................................................................................................long string.";

    console.log(test);

<p class="rm-cfg" data-eval="{mode: 'ruby', lineWrapping: false}"></p>
    require 'pp'
    W, H = 300, 400
    (0...W).each{ |i| p i * i }.map{ |i| [i, i+1] }.flatten
