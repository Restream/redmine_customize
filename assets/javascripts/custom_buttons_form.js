jql(document).ready(function ($) {
  var makeMultiSelect2 = function (selector) {
    $(selector).select2({
      width: "90%",
      multiple: true,
      data: $(selector).data("options")
    });
  };
  makeMultiSelect2("#custom_button_tracker_ids");
  makeMultiSelect2("#custom_button_status_ids");
  makeMultiSelect2("#custom_button_category_ids");
  makeMultiSelect2("#custom_button_author_ids");
  makeMultiSelect2("#custom_button_assigned_to_ids");
  makeMultiSelect2("#custom_button_assigned_to_role_ids");

  // Selecting icons
  function addFontAwesomeIcon(iconName) {
    if (!iconName.id) {
      return iconName.text;
    }
    return $(
      '<span><i class="fa ' + iconName.text + '" aria-hidden="true"></i> ' + iconName.text + '</span>'
    );
  };
  $("#custom_button_icon").select2({
    templateSelection: addFontAwesomeIcon,
    templateResult: addFontAwesomeIcon
  });

  // Make new values select inputs the same
  $('.new-values select').select2();
});
