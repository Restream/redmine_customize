$(document).ready(function(){
  var noteId = /#note-\d+/.exec(window.location.hash);
  if (noteId) $(noteId[0] + ", " + noteId[0] + " > h4").effect('highlight', null, 3000);
});
