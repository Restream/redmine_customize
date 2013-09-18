$(document).ready(function(){
  $("div.contextual").on("click", "a.custom-button", function(e){
    e.preventDefault();
    var new_values = $(this).data("new-values");
    var form = $("form#bulk_edit_form");
    for(var field_name in new_values) {
      if (field_name == "assigned_to_id") {
        form.append("<input type='hidden' id='issue_custom_assigned_to_id' name='issue[custom_assigned_to_id]'/>");
        form.find("#issue_custom_assigned_to_id").val(new_values[field_name]);
      } else {
        form.find("#issue_" + field_name).val(new_values[field_name]);
      }
    }
    form.submit();
  });
});
