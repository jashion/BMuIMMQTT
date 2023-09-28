var aedes = require('aedes')();
var server = require('net').createServer(aedes.handle);

server.listen(10069, function(){  
    console.log('server started and listening on port 10069.');  
});  
  
aedes.on('client', function(client) {
    console.log('client connect: ', client.id);
});

aedes.on('clientReady', function(client) {
    console.log('client is ready.')
})

aedes.on('clientDisconnect', function(client) {
    console.log('client disconnect: ', client.id);
})

aedes.subscribe("bmu.com", async function(packet, callback) {
    callback()
}, () => {
    console.log("订阅（bmu.com）成功")
})

aedes.on("publish", async function (packet, client) {
    if (packet.topic === "bmu.com") {
        console.log("received message: ", packet.payload.toString());
    }
})