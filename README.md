# BMuIMMQTT

This a repository which include some MQTT demos.

###### Client:

The MQTT client is completed by using CocoaMQTT repository.

```swift
import CocoaMQTT


//init mqtt
let clientID = String(ProcessInfo().processIdentifier)
let mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: UInt16(defaultPort))
mqtt!.logLevel = .debug
mqtt!.username = ""
mqtt!.password = ""
mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
mqtt!.keepAlive = 60
mqtt!.delegate = self

//connect
mqtt?.connect()
//disconnect
mqtt?.disconnect()
//subscribe
mqtt?.subscribe(topic)
//publish
mqtt?.pubish(topic, withString: text)

//CocoaMQTTDelegate
//self signed
func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
    print("self signed.")
}

func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    switch ack {
    case .accept:
        mqtt.subscribe(topic)
    default:
    break
    }
}

func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
    print("connect state: " + state.description)
}

func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    print("publish message: \(message.string?.description ?? ""), id: \(id)")
}

func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    print("publish ack id: \(id)")
}

func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16) {
    print("publish complete id: \(id)")
}

func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
    print("receive message: \(message.string?.description ?? ""), topic: \(message.topic), id: \(id)")
}

func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
    print("subscribed: \(topics)")
}

func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    print("unsubscribe: \(topic)")
}

func mqttDidPing(_ mqtt: CocoaMQTT) {
    print("ping")
}

func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    print("pong")
}

func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    print("disconnect")
}
```

###### Server:

You can use free broker.

```swift
//Test broker
let defaultHost = "broker-cn.emqx.io"
let defaultPort = 1883
//    let defaultHost = "localhost"
//    let defaultPort = 10069
```

Or you also can use own server.

```javascript
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
```

###### refrence:

[Node搭建本地MQTT服务器](https://zhuanlan.zhihu.com/p/530011235)

[iOS即时通讯，从入门到“放弃”？](https://www.jianshu.com/p/2dbb360886a8)

[第三章 – MQTT控制报文 - MQTT协议中文版](https://mcxiaoke.gitbook.io/mqtt/03-controlpackets)
