var io = require('socket.io').listen(5001),
    redis = require('redis').createClient();

// TODO: subscribe to something
redis.subscribe('state-change');

io.on('connection', function(socket){
  redis.on('message', function(channel, message){
    console.log(message);
    var parsed = JSON.parse(message);
    socket.emit('state-'+parsed.uid, parsed.state);
  });
});
