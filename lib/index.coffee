extend = require 'extend'
appendCSS = require 'append-css'

hideTag = (qs) ->
  appendCSS """
    #{ qs } {
      width     : 0;
      height    : 0;
      visibility:hidden;
    }
  """

evalAnnotations = (qs, elmSlector) ->
  hideTag(qs)
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


evaluableTag =
  getAnnotations: getAnnotations
  getElements   : getElements


module.exports = evaluableTag
