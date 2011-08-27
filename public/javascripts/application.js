var socket = io.connect('/');

socket.on("name", function(data){
  if(data==="false"){
    alert("You are not accepted!");
  }
});

socket.on("setup", function(data){
  alert("You joined!");
  socket.emit("setPosition", prompt("Move to array ?"));
});

socket.on("playerJoined", function(data){
  alert(data + " joined!");
});

socket.on("playerDisconnected", function(data){
  alert(data + " left!");
});


socket.on("playerMoved", function(data){
  alert(data + " moved!");
});



socket.emit("setName", prompt("What is your name?"));