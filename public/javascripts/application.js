
var position;
var socket = io.connect('/');
var myName = prompt("What is your name?");
socket.emit("setName", myName);

var log = function(text){
  $("#log ul").prepend($("<li>").html(text));
}

socket.on("name", function(data){
  if(data==="false"){
    log("You are not accepted!");
  }
});

socket.on("setup", function(data){
  position = data["players"][myName];
  log("You joined!");
  log("Received setup: "+ JSON.stringify(data));
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

socket.on("setName", function(data) {
  myName = prompt("What is your name?");
  socket.emit("setName", myName);
});


$(document).keydown(function(e){
    if (e.keyCode == 37) {
       position[0] -= 1
       socket.emit("setPosition", position); 
       return false;
    }
    if (e.keyCode == 38) {
       position[1] -= 1
       socket.emit("setPosition", position); 
       return false;
    }
    if (e.keyCode == 39) {
       position[0] += 1
       socket.emit("setPosition", position); 
       return false;
    }
    if (e.keyCode == 40) {
       position[1] += 1
       socket.emit("setPosition", position); 
       return false;
    }
});