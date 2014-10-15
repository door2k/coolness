//
//  appClass.swift
//  coolness
//
//  Created by Tamir Berliner on 10/12/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation
import UIKit

class CNRemoteApp {
    var icon: UIImage
    var name: String = "None"
    var remote: CNRemote
    
    init (name: String, icon: UIImage, appRemote: CNRemote) {
        self.name = name
        self.icon = icon
        self.remote = appRemote
    }
}

class CNRemote {
    var app :String
    
    init (app: String) {
        self.app = app
    }
    
    func mute() {
        network().sendCommand("mute&app=\(self.app)")
    }
    
    func unmute() {
        network().sendCommand("unmute&app=\(self.app)")
    }
    
    func bringToForground() {
        network().sendCommand("appToForground&app=\(self.app)")
    }
    
}

