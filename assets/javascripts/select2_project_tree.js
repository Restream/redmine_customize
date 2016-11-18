jql(document).ready(function ($) {
  // Find children by parent-id data attribute
  function findChildren(option) {
    var allOptions = $(option).closest("select")[0].options;
    var children = [];
    var i, j;
    var id = $(option).data('id');

    if (option.children && option.children.length > 0) {
      children.concat(option.children);
    } else if (id) {
      for (i = 0; i < allOptions.length; i++) {
        var child = allOptions[i];
        if ($(child).data('parent-id') === id) {
          children.push(child);
        }
      }
    }
    j = children.length;
    for (i = 0; i < j; i++) {
      children.concat(findChildren(children[i]));
    }
    return children;
  }

  // Determine if option or its children match the term.
  // Returns boolean
  function isMatchInTree(term, option) {
    // Return true if one of children match the term
    var children = findChildren(option);
    if (children && children.length > 0) {
      for (var i = 0; i < children.length; i++) {
        if (isMatchInTree(term, children[i])) {
          return true;
        }
      }
    }

    // Ignoring case
    var original = '';
    if (option.text != undefined) {
      original = option.text.toUpperCase();
    } else if (option.label != undefined) {
      original = option.label.toUpperCase();
    }
    term = term.toUpperCase();

    // Check if the text contains the term
    if (original.indexOf(term) > -1) {
      return true;
    }

    return false;
  }

  // Customized Select2 matcher function which use isMatchInTree()
  function matcher(params, data) {
    // Always return the object if there is nothing to compare
    if ($.trim(params.term) === '') {
      return data;
    }

    // Do a recursive check for options with children
    if (data.children && data.children.length > 0) {
      // Clone the data object if there are children
      // This is required as we modify the object to remove any non-matches
      var match = $.extend(true, {}, data);

      // Check each child of the option
      for (var c = data.children.length - 1; c >= 0; c--) {
        var child = data.children[c];

        var matches = matcher(params, child);

        // If there wasn't a match, remove the object in the array
        if (matches == null) {
          match.children.splice(c, 1);
        }
      }

      // If any children matched, return the new object
      if (match.children.length > 0) {
        return match;
      }

      // If there were no matching children, check just the plain object
      return matcher(params, match);
    }

    var isMatch = isMatchInTree(params.term, data.element);
    if (isMatch) {
      return data;
    }

    // If it doesn't contain the term, don't return anything
    return null;
  }

  // Add select2 to all projects selectors
  $("#project_quick_jump_box,#custom_button_project_ids").each(function(){

    var projectTree = $(this).select2({
      matcher: matcher,
      templateResult: function (data) {
        // We only really care if there is an element to pull classes from
        if (!data.element) {
          return data.text;
        }
        var $element = $(data.element);
        var $wrapper = $('<span></span>');
        $wrapper.addClass($element[0].className);
        $wrapper.text(data.text);
        return $wrapper;
      }
    });

    // For quick_jump_box we change location after selecting project
    if ($(this)[0].id === "project_quick_jump_box") {

      projectTree.on("select2:select", function (e) {
        var newLocation = $(e.params.data.element).data('jump');
        if (newLocation && newLocation != "") {
          window.location = newLocation;
        }
      });
    }
  });
});
