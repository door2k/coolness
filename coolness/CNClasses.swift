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
    var parameters: [String : String]
    
    init (name: String, icon: UIImage, appRemote: CNRemote) {
        self.name = name
        self.icon = icon
        self.remote = appRemote
        self.parameters = [:]
    }
}





