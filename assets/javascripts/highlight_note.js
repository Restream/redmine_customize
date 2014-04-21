$(document).ready(function(){
  var highlightNote = function() {
    var noteId = /#note-\d+/.exec(window.location.hash);
    if (noteId) $(noteId[0] + ", " + noteId[0] + " > h4").effect('highlight', null, 3000);
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
