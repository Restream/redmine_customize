jql(document).ready(function($){
  var selector = "#project_quick_jump_box";
  var data = $(selector).data("options");
  var placeholder = $(selector).data("placeholder");
  $(selector).select2({
    width: '300px',
    data: data,
    placeholder: placeholder,
    matcher: function(term, text, option) {
      // ignore items without id
      if (option.id == undefined) {
        return false;
      } else {
        return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;
      }
    }
  }).change(function(e) {
    if (e.val != "") { window.location = e.val; }
  }).on("select2-opening", function() {
    var scrollPosition = [
        self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
        self.pageYOffset || document.documentElement.scrollTop  || document.body.scrollTop
    ];
    var html = jQuery('html'); // it would make more sense to apply this to body, but IE7 won't have that
    html.data('scroll-position', scrollPosition);
    html.data('previous-overflow', html.css('overflow'));
    html.css('overflow', 'hidden');
    window.scrollTo(scrollPosition[0], scrollPosition[1]);
  }).on("select2-close", function() {
    var html = jQuery('html');
    var scrollPosition = html.data('scroll-position');
    html.css('overflow', html.data('previous-overflow'));
    window.scrollTo(scrollPosition[0], scrollPosition[1])
  });
});
