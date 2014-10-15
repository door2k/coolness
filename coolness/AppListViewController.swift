//
//  AppTableViewController.swift
//  coolness
//
//  Created by Tamir Berliner on 10/13/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import Foundation
import UIKit

class AppListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var appsTable: UITableView!
    
    var appManager: CNAppsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appManager = CNAppsManager.sharedInstance
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeApp:", name: "ActiveApp", object: nil)
    }

    var appKeys: [String] = []
    func activeApp (notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.appsTable.reloadData()
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appKeys = Array(appManager!.apps.keys)
        return appKeys.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("appCellView") as? UITableViewCell
        
        var appName = appKeys[indexPath.row]
        
        if appName == appManager!.activeApp! {
            cell!.textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 0.1, alpha: 1.0)
        } else {
            cell!.textLabel!.textColor = UIColor.blackColor()
        }

        cell!.imageView!.image = appManager!.apps[appName]!.icon
        cell!.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        cell!.imageView!.clipsToBounds = true;
        cell!.textLabel?.text = appManager!.apps[appName]!.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.appManager?.setActiveApp(appKeys[indexPath.row])
    }
    
    
    
}
