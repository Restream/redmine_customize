$(document).ready(function(){
  $("div.contextual").on("click", "a.custom-button", function(e){
    e.preventDefault();
    var new_values = $(this).data("new-values");
    var form = $("form#issue-form");
    for(var field_name in new_values) {
      form.find("#issue_" + field_name).val(new_values[field_name]);
    }
    form.submit();
  });
});
