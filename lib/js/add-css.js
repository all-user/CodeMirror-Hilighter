(function() {
  var addCSS;

  addCSS = function(rule) {
    var styleEle;
    styleEle = document.createElement('style');
    document.head.appendChild(styleEle);
    return styleEle.sheet.insertRule(rule, 0);
  };

  module.exports = addCSS;

}).call(this);
