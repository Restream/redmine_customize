$(document).ready(function(){
  var highlightNote = function() {
    $("div.journal").removeClass("selected");
    var journalNote;
    var noteId = /#note-\d+/.exec(window.location.hash);
    if (noteId) {
      journalNote = $(noteId[0]).parent();
    } else {
      var changeId = /#change-\d+/.exec(window.location.hash);
      if (changeId) {
        journalNote = $(changeId[0]);
      }
    }
    if (journalNote) {
      journalNote.addClass("selected", 500, "easeInBack");
    }
  };

  highlightNote();

  if ("onhashchange" in window) { // event supported?
    window.onhashchange = highlightNote;
  }
  else { // event not supported:
    var storedHash = window.location.hash;
    window.setInterval(function () {
      if (window.location.hash != storedHash) {
        storedHash = window.location.hash;
        highlightNote();
      }
    }, 100);
  }
});
