addCSS = (rule) ->
  styleEle = document.createElement 'style'
  document.head.appendChild styleEle
  styleEle.sheet.insertRule rule, 0

module.exports = addCSS
