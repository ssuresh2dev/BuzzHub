var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

io.on('connection', function(socket){
  socket.on('buzz', function(playerName, keyName){
  	console.log(playerName + " buzzed")
    io.emit('playerBuzzed', playerName, keyName)

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

app.get('/', function(req, res){
  res.send('<h1>Hello world</h1>');
});

http.listen(8900, function(){
  console.log('listening on *:8900');
});

