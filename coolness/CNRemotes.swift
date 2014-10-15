//
//  CNRemotes.swift
//  coolness
//
//  Created by Tamir Berliner on 10/16/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation
import UIKit

enum CNAppCapabilities : String {
    case SetActive = "SetActive"
    case Play = "Play"
    case Pause = "Pause"
    case IsPlaying = "IsPlaying"
    case GetVolume = "GetVolume"
    case SetVolume = "SetVolume"
    case FullScreen = "FullScreen"
    case Seek = "Seek"
    case Next = "Next"
    case Previous = "Previous"
    
    static let allValues = [SetActive,Play,Pause,IsPlaying,GetVolume,SetVolume,FullScreen,Seek,Next,Previous]
}

class CNRemote {
    var app :String
    var capabilities: [CNAppCapabilities : Bool]
    
    func initCapabilities(appCapabilities: [CNAppCapabilities]) {
        
        for capability in CNAppCapabilities.allValues {
            self.capabilities[capability] = false
        }
        
        for capability in appCapabilities {
            self.capabilities[capability] = true
        }
    }
    
    init (app: String, appCapabilities: [CNAppCapabilities]) {
        self.app = app
        self.capabilities = [:]
        
        self.initCapabilities(appCapabilities)
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
    
    func getVolume() {
        network().getVolume()
    }
    
    func setVolume(volume: Float) {
        network().setVolume(volume)
    }
    
    func supports(capability: CNAppCapabilities) -> Bool {
        return self.capabilities[capability]!
    }
    
    func useCapability(capability: CNAppCapabilities) {
        if self.capabilities[capability] == true {
            network().sendCommand("\(capability.toRaw())&app=\(self.app)")
        }
    }
}
