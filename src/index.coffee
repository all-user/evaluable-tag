extend = require 'extend'
appendCSS = require 'append-css'

hidQueries = []

_hide = (qs) ->
  appendCSS """
    #{ qs } {
      width      : 0;
      height     : 0;
      line-height: 0;
      visibility : hidden;
      margin     : 0;
      padding    : 0;
    }
  """

_eval = (qs, select) ->
  tags = document.querySelectorAll qs
  [].map.call tags, (tag) ->
    target = select tag
    res = eval "(#{ tag.getAttribute 'data-eval' })"
    annotation: tag
    annotated : target
    result    : res

evalAnnotationsBy = (qs) ->
  if hidQueries.indexOf(qs) is -1
    hidQueries.push qs
    _hide(qs)
  _eval qs, (tag) ->
    target = tag.nextSibling
    target = target.nextSibling while target?.nodeType == Node.TEXT_NODE
    target

evalBy = (qs) ->
  _eval qs, (tag) -> tag


EvaluableTag =
  evalAnnotationsBy: evalAnnotationsBy
  evalBy           : evalBy

module.exports = EvaluableTag
