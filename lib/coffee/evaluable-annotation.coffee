extend = require 'extend'
addCSS = require './add-css'

hideAnnotations = (qs) ->
  addCSS """
    #{ qs } {
      width     : 0;
      height    : 0;
      visibility:hidden;
    }
  """

evalAnnotations = (qs, elmSlector) ->
  annotations = document.querySelectorAll qs
  [].map.call annotations, (annot) ->
    elm = elmSlector annot
    data = eval "(#{ annot.getAttribute 'data-eval' })"
    ref : annot
    elm : elm
    data: data

getAnnotations = (qs) ->
  evalAnnotations qs, (annot) ->
    elm = annot.nextSibling
    elm = elm.nextSibling while elm?.nodeType == Node.TEXT_NODE
    elm

getElements = (qs) ->
  evalAnnotations qs, (annot) -> annot


EvaluableAnnotation =
  getAnnotations: getAnnotations
  getElements   : getElements


module.exports = EvaluableAnnotation
