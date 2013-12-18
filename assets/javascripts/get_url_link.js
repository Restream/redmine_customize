$(document).ready(function(){
  $('form#issue-form').on('click', 'a#get-url-link', function(ev) {
    $.post($(this).data('url'), $('#issue-form').serialize())
      .done(function(data) {
        window.prompt ("URL for this form:", data);
      });
    ev.stopPropagation();
    return false;
  });
});
