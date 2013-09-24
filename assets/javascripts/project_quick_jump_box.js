$(document).ready(function(){
  var selector = "#project_quick_jump_box";
  var data = $(selector).data("options");
  var placeholder = $(selector).data("placeholder");
  $(selector).select2({
    width: '300px',
    data: data,
    placeholder: placeholder,
    matcher: function(term, text, option) {
      // ignore groups
      if (option.children == undefined) {
        return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;
      } else {
        return false;
      }
    }
  }).change(function(e) {
    if (e.val != "") { window.location = e.val; }
  });
});
