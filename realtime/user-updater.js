var io = require('socket.io').listen(5001),
    redis = require('redis').createClient();

// TODO: subscribe to something
// redis.subscribe('');

io.on('connection', function(socket){
  redis.on('message', function(channel, message){
    // socket.emit('rt-change', JSON.parse(message));
  });
});
