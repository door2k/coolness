//
//  AppTableViewController.swift
//  coolness
//
//  Created by Tamir Berliner on 10/13/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation
import UIKit

class AppListViewController : UIViewController, UITableViewDataSource  {
    
    var apps: [String : CNRemoteApp]?
    var activeApp: String?
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    
    @IBOutlet weak var appsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apps = [:]
        self.apps!["None"] = CNRemoteApp(name: "None", icon: UIImage(named: "None_Icon"), appRemote: CNRemote(app: "None"))
        self.activeApp = "None"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeWindow:", name: "ActiveWindow", object: nil)
    }

    func activeWindow (notification: NSNotification) {
        var name: String = notification.object as NSString
        
        activeApp! = name
        
        if (self.apps![name] != nil) {
            
        } else {
            NSLog("Adding: \(name)")
            switch name {
            case "VLC":
                self.apps![name] = CNRemoteApp(name: name, icon: UIImage (named: "VLC_Icon"), appRemote: CNRemote(app: name))
            case "Google Chrome":
                self.apps![name] = CNRemoteApp(name: name, icon: UIImage (named: "Google_Chrome_Icon"), appRemote: CNRemote(app: name))
            default:
                self.apps![name] = CNRemoteApp(name: name, icon: UIImage(named: "None_Icon"), appRemote: CNRemote(app: name))
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.appsTable.reloadData()
        })
    }
    
    var appKeys: [String] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("Got \(apps!.count) cells")
        appKeys =  Array(apps!.keys)
        for s in appKeys {
            NSLog("Item in appKeys: \(s)")
        }
        return apps!.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("appCellView") as? UITableViewCell
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "appCell")
//        }
        
        var appName: String = appKeys[indexPath.row]
        if appName == activeApp {
//            cell!.backgroundColor = UIColor(red: 0.0, green: 0.9, blue: 0.0, alpha: 1.0)
            cell!.textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 0.1, alpha: 1.0)
        } else {
            cell!.textLabel!.textColor = UIColor.blackColor()
        }
        NSLog("Adding Cell \(indexPath.row) with item \(appName):\(apps?[appName]?.name)")
        cell!.imageView!.image = apps?[appName]?.icon
        cell!.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
//        cell!.imageView!.contentMode = UIViewContentMode.Center

        cell!.imageView!.clipsToBounds = true;
        cell!.textLabel?.text = apps?[appName]?.name
        
        return cell!
    }
    
}
