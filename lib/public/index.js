var token = document.getElementById("auth_token").value;
setInterval(function() {

  $.ajax({
    url: "/door_state?auth_token=" + token,
    dataType: "text"
  }).done(function(data) {
    console.log(data);
    var current = $("#garage_state").text();
    if(current !== data) {
      $("#garage_state").text(data);
    }
  });
}, 5000);