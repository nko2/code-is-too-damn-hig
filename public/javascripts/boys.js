var socket = io.connect('/');
var myName = "";
var boyList = [];
var step = 0;
var STEP_REQUIRED = 8;
window.onload = function() {
  myName = prompt("What is your name?");
  socket.emit("login", myName);

var log = function(text){
  $("#log ul").prepend($("<li>").html(text));
}

socket.on("name", function(data){
  if(data==="false"){
    log("You are not accepted!");
  }
});

socket.on("setup", function(data){
  setupGame(data);
  log("You joined!");
  log("Received setup: "+ JSON.stringify(data));
});

socket.on("playerJoined", function(data){
  log(data.name + " joined at "+data.position[0]+","+data.position[1]+"!");
  Boy.createBoy("", data);
});

socket.on("playerDisconnected", function(data){
  log(data + " left!");
});


socket.on("playerMoved", function(data){
  log(data.name + " moved to "+data.position[0]+","+data.position[1]+"!");
  for(var boy in boyList) {
    var playerBoy = boyList[boy];
    if(playerBoy.name == data.name) {
      playerBoy.x = data.position[0] * 16;
      playerBoy.y = data.position[1] * 16;
    }
  }
});

socket.on("invalidName", function(data) {
  myName = prompt("What is your name?");
  socket.emit("login", myName);
});


}


var Boy = (function() {

	return {
		createBoy : function(name, player) {
		  var isMyPlayer = (myName === name);
			var newPlayer = Crafty.e("2D, Canvas, player, Keyboard, CustomControls, SpriteAnimation, Collision")
			.attr({x: player.position[0]*16, 
			      y: player.position[1]*16, 
			      z: 1 , 
			      tilePosition : player.position,
			      score: player.score, 
			      name: name, 
			      isMain : isMyPlayer,
			      moveLeft : false, moveRight : false, moveUp : false, moveDown : false})
			.animate("walk_left", 6, 3, 8)
			.animate("walk_right", 9, 3, 11)
			.animate("walk_up", 3, 3, 5)
			.animate("walk_down", 0, 3, 2)
			.bind("EnterFrame", function(e) {
			  if(this.moveLeft) {
			    if(!this.isPlaying("walk_left"))
			      this.stop().animate("walk_left", 16);
			    }
			    if(this.moveRight) {
			      if(!this.isPlaying("walk_right"))
			        this.stop().animate("walk_right", 16);
			    }
			    if(this.moveUp) {
			      if(!this.isPlaying("walk_up"))
			        this.stop().animate("walk_up", 16);
			    }
			    if(this.moveDown) {
			      if(!this.isPlaying("walk_down"))
			        this.stop().animate("walk_down", 16);
			    }
			  })
			.bind("KeyUp", function(e) {
			    this.stop();
			  })
			.collision()
			.onHit("wall_left", function() {
			  this.x += this._speed;
			  this.stop();
			  })
			.onHit("wall_right", function() {
			  this.x -= this._speed;
			  this.stop();
			  })
			.onHit("wall_bottom", function() {
			  this.y -= this._speed;
			  this.stop();
			  })
			.onHit("wall_top", function() {
			  this.y += this._speed;
			  this.stop();
			  })
			.onHit("flower", function(hit) {
        console.log("FUCK");
			});

			boyList.push(newPlayer);
			
      if(isMyPlayer) {
        newPlayer.CustomControls(16);
      }
      
			return newPlayer;
		},
		
		isMainBoy : function() {
			return this.isMain;
		},
		stopBoy : function(player) {
			player.moveLeft = player.moveDown = player.moveUp = player.moveRight = false;
			//Crafty.trigger("KeyUp");
		},
		killBoy : function(player) {
			player.destroy();
		},
		moveBoy : function(player, dir) {

			player.moveLeft = player.moveDown = player.moveUp = player.moveRight = false;

			if(dir === "left")
				player.moveLeft = true;
			else if(dir === "right")
				player.moveRight = true;
			else if(dir === "up")
				player.moveUp = true;
			else if(dir === "down")
				player.moveDown = true;

		}
	}

})();


function setupGame(setUpData) {

	Crafty.init(400, 400);

	Crafty.sprite(16, "/images/sprite.png", {
		grass1 : [0, 0],
		grass2 : [1, 0],
		grass3 : [2, 0],
		grass4 : [3, 0],
		flower : [0, 1],
		bush1 : [0, 2],
		bush2 : [1, 2],
		player : [0, 3]
	});

	//method to randomy generate the map
	function generateWorld() {

		Crafty.background("#000");
		//generate the grass along the x-axis
		for(var i = 0; i < 25; i++) {
			//generate the grass along the y-axis
			for(var j = 0; j < 25; j++) {
				grassType = Crafty.randRange(1, 4);
				Crafty.e("2D, Canvas, grass"+grassType)
				.attr({
					x : i * 16,
					y : j * 16
				});

				//1/40 chance of drawing a flower and only within the bushes
        //         if(i > 0 && i < 24 && j > 0 && j < 24 && Crafty.randRange(0, 30) > 29) {
        //          spot = Crafty.e("2D, Canvas, flower, SpriteAnimation")
        //          .attr({x: i * 16, y: j * 16, z: 2})
        //          .animate("wind", 0, 1, 3)
        //          .bind("EnterFrame", function() {
        //            if(!this.isPlaying()) {
        //              this.animate("wind", 40);
        //            }
        //          });
        //         
        // }

			}
		}
		for(var i = 0; i < setUpData.flowersOnMap.length; i++){

		    var flowerX = setUpData.flowersOnMap[i][0];
		    var flowerY = setUpData.flowersOnMap[i][1];
         spot = Crafty.e("2D, Canvas, flower, SpriteAnimation")
         .attr({x: flowerX * 16, y: flowerY * 16})
         .animate("wind", 0, 1, 3)
         .bind("EnterFrame", function() {
           if(!this.isPlaying()) {
             this.animate("wind", 40);
           }
         });
		  
		}

		//create the bushes along the x-axis which will form the boundaries
		for(var i = 0; i < 25; i++) {
			Crafty.e("2D, Canvas, wall_top, bush"+Crafty.randRange(1,2))
			.attr({
				x : i * 16,
				y : 0,
				z : 2
			});
			Crafty.e("2D, Canvas, wall_bottom, bush"+Crafty.randRange(1,2))
			.attr({
				x : i * 16,
				y : 384,
				z : 2
			});
		}

		//create the bushes along the y-axis
		//we need to start one more and one less to not overlap the previous bushes
		for(var i = 1; i < 24; i++) {
			Crafty.e("2D, Canvas, wall_left, bush"+Crafty.randRange(1,2))
			.attr({
				x : 0,
				y : i * 16,
				z : 2
			});
			Crafty.e("2D, Canvas, wall_right, bush"+Crafty.randRange(1,2))
			.attr({
				x : 384,
				y : i * 16,
				z : 2
			});
		}

	};

	//end generateWorld()

	//the loading screen that will display while our assets load
	Crafty.scene("loading", function() {
		//load takes an array of assets and a callback when complete
		Crafty.load(["/images/sprite.png"], function() {
			Crafty.scene("main");
			//when everything is loaded, run the main scene
		});
		//black background with some loading text
		Crafty.background("#fff");
		Crafty.e("2D, DOM, Text")
		.text("Loading")
		.css({"text-align": "center" , "color": "#f00"})
		.draw("20", "150", "200", "50");
		;

	});
	//automatically play the loading scene
	Crafty.scene("loading");

	Crafty.scene("main", function() {

		generateWorld();

		Crafty.c('CustomControls', {
			__move : {
				left : false,
				right : false,
				up : false,
				down : false
			},
			_speed : 16,

			CustomControls : function(speed) {
				if(speed)
					this._speed = speed;

				this.bind('EnterFrame', function() {
				//move the player in a direction depending on the booleans
				//only move the player in one direction at a time (up/down/left/right)
				  step++;
				  if(step >= STEP_REQUIRED) {
				    if(this.moveRight) this.x += this._speed;
				    else if(this.moveLeft) this.x -= this._speed;
				    else if(this.moveUp) this.y -= this._speed;
				    else if(this.moveDown) this.y += this._speed;
            var tileY = Math.floor(this.y / 16.0);
            var tilyX = Math.floor(this.x / 16.0);
            var tilePosition = [tilyX, tileY];
            if( tilyX != this.tilePosition[0] || tileY != this.tilePosition[1] ){
              this.tilePosition = tilePosition;  
              socket.emit("moveTo", tilePosition); 
            }
            step = 0;
          }
          
          
				}).bind('KeyDown', function(e) {
				//default movement booleans to false
				  this.moveRight = this.moveLeft = this.moveDown = this.moveDown = false;

				//if keys are down, set the direction
				  if(e.keyCode === Crafty.keys.RIGHT_ARROW) this.moveRight = true;
				  if(e.keyCode === Crafty.keys.LEFT_ARROW) this.moveLeft = true;
				  if(e.keyCode === Crafty.keys.UP_ARROW) this.moveUp = true;
				  if(e.keyCode === Crafty.keys.DOWN_ARROW) this.moveDown = true;

				}).bind('KeyUp', function(e) {
					//if key is released, stop moving
					if(e.keyCode === Crafty.keys.RIGHT_ARROW)
						this.moveRight = false;
					if(e.keyCode === Crafty.keys.LEFT_ARROW)
						this.moveLeft = false;
					if(e.keyCode === Crafty.keys.UP_ARROW)
						this.moveUp = false;
					if(e.keyCode === Crafty.keys.DOWN_ARROW)
						this.moveDown = false;

					// this.preventTypeaheadFind(e);
				});
				return this;
			}
		});
    
    for(var player in setUpData.players) {
      Boy.createBoy(player, setUpData.players[player]);
    }
    
	});
}