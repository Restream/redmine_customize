$(document).ready(function(){
  var makeMultiSelect2 = function(selector) {
    $(selector).select2({
      width: "90%",
      multiple: true,
      data: $(selector).data("options"),
      matcher: function(term, text, option) {
        // ignore groups
        if (option.children == undefined) {
          return text.toUpperCase().indexOf(term.toUpperCase()) >=0;
        } else {
          return false;
        }
      }
    });
  };
  makeMultiSelect2("#custom_button_project_ids");
  makeMultiSelect2("#custom_button_tracker_ids");
  makeMultiSelect2("#custom_button_status_ids");
  makeMultiSelect2("#custom_button_category_ids");
  makeMultiSelect2("#custom_button_author_ids");
  makeMultiSelect2("#custom_button_assigned_to_ids");
  makeMultiSelect2("#custom_button_assigned_to_role_ids");
});
