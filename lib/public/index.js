var token = document.getElementById("auth_token").value;
var submitted = false;

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
}, 3000);

$("#opener").bind('touchstart mousedown', function() {
  if(!submitted) {
    if($("#passcode").val() == "") {
      alert("You must enter the door code to continue");
      return false;
    }
    $("#door_form").submit();
  }
  submitted = true;
});
