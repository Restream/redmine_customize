jql(document).ready(function($){
  $.fn.select2.defaults.set("theme", "classic");
  $('#issue-form').each(function(){
    $(document).keydown(function(event){
      var cmdPressed = !event.altKey && !event.shiftKey;
      if (navigator.appVersion.indexOf("Mac") != -1) {
        cmdPressed = cmdPressed && event.metaKey && !event.ctrlKey;
      } else {
        cmdPressed = cmdPressed && event.ctrlKey;
      }
      if (cmdPressed && event.keyCode == 13) {
        event.preventDefault();
        event.stopPropagation();
        $('textarea').blur();
        $('textarea').removeData('changed');
        $('#issue-form').submit();
      }
    });
  });
});
