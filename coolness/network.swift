//
//  network.swift
//  coolness
//
//  Created by Tamir Berliner on 10/6/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation

class network {
    var server: String
    var port: String
    var user: String
    
    func getcommandURL(command: String) -> NSURL {
        return NSURL(string: "http://\(server):\(port)/send_key?action=\(command)&user=\(user)")
    }
    
    func getFGWindowURL() -> NSURL {
        return NSURL(string: "http://\(server):\(port)/active_window?user=\(user)")
    }
    
    func sendCommand(command: String) {
        let url:NSURL = getcommandURL(command)
//        println("sending command: \(url)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getActiveWindow() {
        let url:NSURL = getFGWindowURL()
//        println("getting FG window command: \(url)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ActiveWindow", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getVolume() {
        let url:NSURL = getcommandURL("get_volume")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "VolumeUpdate", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }

    func setVolume (volume: Float) {
        sendCommand("set_volume&Volume=\(volume)")
    }
    
    init ()
    {
        var config = appConfig() // makes sure username, server, port are defined
        self.user = config.params["username"]!
        self.server = config.params["server"]!
        self.port = config.params["port"]!
    }
}

