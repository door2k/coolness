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
        return NSURL(string: "http://\(server):\(port)/send_key?Action=\(command)&User=\(user)")
    }
    
    func sendCommand(command: String) {
        let url:NSURL = getcommandURL(command)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
        // TODO: implement code for a success/failed request
        }
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getActiveWindow(currentAppName: String) {
        let urlUnsurpressedString: NSString = "http://\(server):\(port)/active_window?Window=\(currentAppName)&User=\(user)"
        let urlString: NSString = urlUnsurpressedString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url:NSURL = NSURL(string: urlString)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            NSLog(NSString(data: data, encoding: NSUTF8StringEncoding))
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ActiveWindow", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }
    
    func getAppList() {
        NSLog(server)
        let url = NSURL(string: "http://\(server):\(port)/windows_list?User=\(user)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            NSLog(NSString(data: data, encoding: NSUTF8StringEncoding))
           
            let ob = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
            if (ob != nil) {
                let jsonDict = ob as NSDictionary
                NSLog("JSON: \(jsonDict)")
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "AppsList", object: jsonDict))
            }
        }
        
        task.resume() //a-sync, doesn't wait for server.
        
        
    }
    
    func getVolume() {
        let url:NSURL = getcommandURL("GetVolume")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "VolumeUpdate", object: NSString(data: data, encoding: NSUTF8StringEncoding)))
        }
        
        task.resume() //a-sync, doesn't wait for server.
    }

    func setVolume (volume: Float) {
        sendCommand("SetVolume&Volume=\(volume)")
    }
    
    func setActiveApp (name: String) {
        let urlUnsurpressedString: NSString = "http://\(server):\(port)/activate?Window=\(name)&User=\(user)"
        let urlString: NSString = urlUnsurpressedString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url:NSURL = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            // TODO: implement code for a success/failed request
        }
        task.resume() //a-sync, doesn't wait for server.

    }
    
    
    init ()
    {
        var config = appConfig() // makes sure username, server, port are defined
        self.user = config.params["username"]!
        self.server = config.params["server"]!
        self.port = config.params["port"]!
        NSLog("Server: \(server)")
    }
}

