// Headers of blocks
var sidebarBlockHeaders = 'div#sidebar h3';
var sidebarBlockUntil = 'div#sidebar > h3, div#sidebar > div#watchers, div#sidebar > form';
var sidebarCollapsedClass = 'collapsed';
var sidebarUpdateUrl = '';

var updateSidebarClasses = function() {
  $(sidebarBlockHeaders).each(function(_, header) {
    var blockContent = $(header).nextUntil(sidebarBlockUntil);
    if ($(header).hasClass(sidebarCollapsedClass)) {
      blockContent.addClass(sidebarCollapsedClass);
    } else {
      blockContent.removeClass(sidebarCollapsedClass);
    }
  });
  return false;
};

var sidebarBlockName = function(block) {
  if ($(block).parent('div#watchers').length) {
    // instead of "Watchers (XX)" just use "Watchers"
    return 'Watchers'
  } else {
    return $(block).text();
  }
};

// load state from div@sidebar data attribute
var initSidebar = function(updateUrl, collapsedBlocks) {
  sidebarUpdateUrl = updateUrl;
  $(sidebarBlockHeaders).each(function(_, header) {
    if (jQuery.inArray(sidebarBlockName(header), collapsedBlocks) >= 0) {
      $(header).addClass(sidebarCollapsedClass);
    }
  });
  updateSidebarClasses();
  return false;
};

var saveSidebarBlockState = function(block) {
  var url = sidebarUpdateUrl + encodeURI(sidebarBlockName(block));
  var isCollapsed = $(block).hasClass(sidebarCollapsedClass);
  $.ajax({
    url: url,
    data: {
      block: {
        is_collapsed: isCollapsed
      }
    },
    type: 'PUT',
    beforeSend: function(){ $('div#sidebar').addClass('ajax-loading'); },
    complete: function(){ $('div#sidebar').removeClass('ajax-loading'); }
  });
  return false;
};

$(document).ready(function(){
  $('div#sidebar').on('click', 'h3', function(ev) {
    $(this).toggleClass(sidebarCollapsedClass);
    updateSidebarClasses();
    ev.stopPropagation();
    saveSidebarBlockState(this);
    return false;
  });
});
