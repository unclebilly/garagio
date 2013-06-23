setInterval(function() {
  $.ajax({
    url: "/door_state",
    dataType: "text"
  }).done(function(data) {
    console.log(data);
    var current = $("#garage_state").text();
    if(current !== data) {
      $("#garage_state").text(data);
      var buttonText = data == "open" ? "Close" : "Open"
      $("#opener").text(buttonText);
    }
  });
}, 5000);