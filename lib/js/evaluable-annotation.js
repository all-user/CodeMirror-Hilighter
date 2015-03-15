(function() {
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

}).call(this);
