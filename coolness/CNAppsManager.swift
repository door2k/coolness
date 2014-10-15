//
//  CNAppsManager.swift
//  coolness
//
//  Created by Tamir Berliner on 10/14/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation
import UIKit

class CNAppsManager : NSObject {

    var apps: [String : CNRemoteApp] = [:]
    var fgAppName:String?
    var initializing: Bool = true
    
    class var sharedInstance :CNAppsManager {
    
        struct Singleton {
            static let instance = CNAppsManager()
        }
        
        if Singleton.instance.initializing {
            NSNotificationCenter.defaultCenter().addObserver(Singleton.instance, selector: "activeWindow:", name: "ActiveWindow", object: nil)
            network().getActiveWindow("None")
            }
        Singleton.instance.initializing = false
        return Singleton.instance
    }
    
    
    func addApp(name: String) {
        switch name {
            case "VLC":
                CNAppsManager.sharedInstance.apps[name] = CNRemoteApp(name: name, icon: UIImage (named: "VLC_Icon"), appRemote: CNRemote(app: name))
            case "Google Chrome":
                CNAppsManager.sharedInstance.apps[name] = CNRemoteApp(name: name, icon: UIImage (named: "Google_Chrome_Icon"), appRemote: CNRemote(app: name))
            default:
                CNAppsManager.sharedInstance.apps[name] = CNRemoteApp(name: name, icon: UIImage(named: "None_Icon"), appRemote: CNRemote(app: name))
        }
    }
    
    func activeWindow (notification: NSNotification) {
        var name: NSString = notification.object as NSString
        
        if (CNAppsManager.sharedInstance.apps[name] == nil) {
            NSLog("Adding: \(name)")
            CNAppsManager.sharedInstance.addApp(name)
        }
        
        CNAppsManager.sharedInstance.activeApp = name
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ActiveApp", object: CNAppsManager.sharedInstance.apps[name]))
        network().getActiveWindow(CNAppsManager.sharedInstance.activeApp!)
    }

    
    var activeApp:String?
        {
        set {
            fgAppName = newValue
        }
        get {
            return fgAppName
        }
    }
}