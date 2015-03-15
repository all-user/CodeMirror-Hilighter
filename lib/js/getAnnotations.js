(function() {
  var getAnnotations;

  getAnnotations = function(qs) {
    var annotations;
    annotations = document.querySelectorAll(qs);
    return [].map.call(annotations, function(annot) {
      var data, elm;
      elm = annot.nextSibling;
      while (elm.nodeType === Node.TEXT_NODE) {
        elm = elm.nextSibling;
      }
      if (!elm) {
        return;
      }
      data = eval("(" + (annot.getAttribute('data-eval')) + ")");
      return {
        ref: annot,
        elm: elm,
        data: data
      };
    });
  };

  module.exports = getAnnotations;

}).call(this);
