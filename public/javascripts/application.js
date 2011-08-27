var socket = io.connect('/');

socket.on("name", function(data){
  if(data==="true"){
    alert("You are accepted!")
  }else{
    alert("You are not accepted!")
  }
});
socket.emit("name", prompt("What is your name?"))