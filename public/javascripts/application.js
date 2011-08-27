var socket = io.connect('/');
var log = function(text){
  $("#log ul").append($("<li>").html(text));
}

socket.on("name", function(data){
  if(data==="false"){
    log("You are not accepted!");
  }
});

socket.on("setup", function(data){
  log("You joined!");
  log("Received setup: "+ JSON.stringify(data));
  socket.emit("setPosition", prompt("Move to array ?").split(","));
});

socket.on("playerJoined", function(data){
  log(data.name + " joined at "+data.position[0]+","+data.position[1]+"!");
});

socket.on("playerDisconnected", function(data){
  log(data + " left!");
});


socket.on("playerMoved", function(data){
  log(data.name + " moved to "+data.position[0]+","+data.position[1]+"!");
});



socket.emit("setName", prompt("What is your name?"));