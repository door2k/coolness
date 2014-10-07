//
//  appConfig.swift
//  coolness
//
//  Created by Tamir Berliner on 10/6/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation


// BRAINLESS: just use appConfig(["key" : "value"]) and it will automatically be remembered and saved in app
//            storage + remembered as default. use a key: appConfig().params["key"].
//            TO ADD/UPDATE you must use the respective methods .add .updates

class appConfig {
    var params: [String : String] = [
        "username"  : "test",
        "server"    : "10.0.0.47",
        "port"      : "5000",
        "region"    : "Home",
        "macmini_uuid"  : "B48AC6FE-2CB5-4F5A-B95F-058CE7127685",
        "macair_uuid"   : "1CCA025F-5B41-4390-9005-C375347C7C83",
        "test"      : "1"
    ]
    
    init (defaultValues: [String:String]) {
        
        for (key, value) in defaultValues {
            self.params[key] = value
        }

        for (key, value) in self.params {
            if NSUserDefaults().valueForKey(key) == nil {
                NSUserDefaults().setValue(value, forKey: key)
            } else {
                params[key] = (NSUserDefaults().valueForKey(key) as String)
            }
        }
    }
    
    convenience init () {
        self.init(defaultValues: [:])
    }
    
    func add(key: String, value: String) {
        self.update(key, value: value)
    }
    
    func update(key: String, value: String) {
        NSUserDefaults().setValue(value, forKey: key)
    }
    
    func debug() {
        for (key, value) in params {
            NSLog("\(key) : \(value)")
        }
    }
}