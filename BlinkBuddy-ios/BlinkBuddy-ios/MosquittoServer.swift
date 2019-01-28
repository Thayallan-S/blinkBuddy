//
//  MosquittoServer.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-27.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//


import UIKit
import Foundation
import Moscapsule

class MosquittoServer: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MosquittoServer {
    func open(){
        let mqttConfig = MQTTConfig(clientId: "iLoveDhruv", host: "broker.mqtt-dashboard.com", port: 1883, keepAlive: 600)
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username: "", password: "")
        mqttConfig.cleanSession = true
        mqttConfig.onMessageCallback = { mqttMessage in
            //NSLog("MQTT Message received: payload=\(mqttMessage.payloadString?.first)")
            print("\(mqttMessage.payloadString!)")
        }
        
        let mqttClient = MQTT.newConnection(mqttConfig)
        
        //print("fuck salopan")
        //print("\(mqttClient.isConnected)")
        
        mqttClient.subscribe("chute", qos: 2)
        
        //lol
        let deadline = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            mqttClient.publish(string: "OPEN", topic: "blinkbuddy", qos: 0, retain: true)
            print("\(mqttClient.isConnected)")
            
        })
    }
    func close() {
        let mqttConfig = MQTTConfig(clientId: "iLoveDhruv", host: "broker.mqtt-dashboard.com", port: 1883, keepAlive: 600)
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username: "", password: "")
        mqttConfig.cleanSession = true
        mqttConfig.onMessageCallback = { mqttMessage in
            //NSLog("MQTT Message received: payload=\(mqttMessage.payloadString?.first)")
            print("\(mqttMessage.payloadString!)")
        }
        
        let mqttClient = MQTT.newConnection(mqttConfig)
        
        print("fuck salopan")
        //print("\(mqttClient.isConnected)")
        
        mqttClient.subscribe("chute", qos: 2)
        
        //lol
        let deadline = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            mqttClient.publish(string: "CLOSE", topic: "blinkbuddy", qos: 0, retain: true)
            print("\(mqttClient.isConnected)")
            
        })
    }
}

