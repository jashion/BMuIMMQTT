//
//  ViewController.swift
//  BMuMQTTClientSwift
//
//  Created by Jashion on 2023/9/27.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, CocoaMQTTDelegate {
    let defaultHost = "localhost"
    let defaultPort = 10069
    //Test broker
//    let defaultHost = "broker-cn.emqx.io"
//    let defaultPort = 1883
    
    let topic: String = "bmu.com"

    @IBOutlet var textField: UITextField!
    
    var mqtt: CocoaMQTT?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMQTT()
    }
    
    func initMQTT() {
        let clientID = String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: UInt16(defaultPort))
        mqtt!.logLevel = .debug
        mqtt!.username = ""
        mqtt!.password = ""
        mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard mqtt != nil else {
            return
        }
        
        if let text = textField.text, !text.isEmpty {
            mqtt?.publish(topic, withString: text)
        }
    }
    
    @IBAction func connectAction(_ sender: Any) {
        if mqtt == nil {
            initMQTT()
        }
        _ = mqtt?.connect()
    }
    
    @IBAction func disconnectAction(_ sender: Any) {
        guard mqtt != nil else {
            return
        }
        mqtt?.disconnect()
        mqtt = nil
    }
    
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
}

