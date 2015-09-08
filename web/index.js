var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

io.on('connection', function(socket){
  socket.on('buzz', function(msg){
  	console.log(msg + " buzzed")
    io.emit('playerBuzzed', msg)

  });
  socket.on('keyGenerate', function(keyName){
  	console.log(keyName)
  });
  socket.on('joinGroup', function(keyName, playerName){
  	console.log(playerName + " joined " + keyName)
  	io.emit('addNew', keyName, playerName)
  });
  socket.on('startGame', function(keyName){
  	io.emit('moveToBuzz', keyName)
  });
  socket.on('resetBuzzers', function(msg){
  	io.emit("buzzerReset", msg)
  });
});


http.listen(8901, function(){
  console.log('listening on *:8901');
});

