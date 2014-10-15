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
    
    func sendCommand(command: String) {
        let url:NSURL = getcommandURL(command)
//        println("sending command: \(url)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getActiveWindow(currentAppName: String) {
        let urlUnsurpressedString: NSString = "http://\(server):\(port)/active_window?window=\(currentAppName)&user=\(user)"
//        NSLog(urlUnsurpressedString)
        let urlString: NSString = urlUnsurpressedString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        NSLog(urlString)
        let url:NSURL = NSURL(string: urlString)
//        NSLog("\(url.absoluteString)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            NSLog(NSString(data: data, encoding: NSUTF8StringEncoding))
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ActiveWindow", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getVolume() {
        NSLog("Tried to get volume. blocked.")
        return
        
        let url:NSURL = getcommandURL("get_volume")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "VolumeUpdate", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }

    func setVolume (volume: Float) {
        
        NSLog("Tried to set volume. blocked.")
        return
        
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

