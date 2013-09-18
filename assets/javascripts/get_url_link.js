$(document).ready(function(){
  $('form#issue-form').on('click', 'a#get-url-link', function(ev) {
    var url = window.location.origin +
        window.location.pathname + '?' +
        $('form#issue-form').serialize();
    window.prompt ("URL for this form:                                               ", url);
    ev.stopPropagation();
    return false;
  });
});
