setInterval(function() {
  $.ajax({
    url: "/door_state",
    dataType: "text"
  }).done(function(data) {
    console.log(data);
    var current = $("#garage_state").text();
    if(current !== data) {
      var opposite = data == "open" ? "closed" : "open";
      $("#garage_door").toggleClass(opposite + " " + data);
      $("#garage_state").text(data);
    }
  });
}, 5000);