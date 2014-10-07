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
    
    func getURL(command: String) -> NSURL {
        return NSURL(string: "http://\(server):\(port)/send_key?action=\(command)&user=\(user)")
    }
    
    func sendCommand(command: String) {
        let url:NSURL = getURL(command)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    init ()
    {
        var config = appConfig() // makes sure username, server, port are defined
        self.user = config.params["username"]!
        self.server = config.params["server"]!
        self.port = config.params["port"]!
    }
}

