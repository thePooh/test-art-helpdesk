$(document).ready(function() {
  // TODO: move this to separate file and resolve connection address
  var socket = io.connect("http://0.0.0.0:5001");

  $(".dynamic-state").each(function(i, o) {
    var obj = $(o)
    socket.on("state-"+obj.data("uid"), function(message) {
      obj.text(message);
    });
  });
});
