$(document).ready(function(){
  $('form#issue-form').on('click', 'a#get-url-link', function(ev) {
    var formData = $('form#issue-form').serializeArray();
    var filteredData = [];
    $.each(formData, function(index, field) {
      if (field.name != "authenticity_token" && field.value != "")
        filteredData.push(field);
    });

    var url = window.location.origin +
      window.location.pathname + '?' +
      $.param(filteredData);

    window.prompt ("URL for this form:                                               ", url);

    ev.stopPropagation();
    return false;
  });
});
