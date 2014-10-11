//
//  SecondViewController.swift
//  coolness
//
//  Created by Tamir Berliner on 10/1/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var secondLable: UILabel!
    var connected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //regionLabel.textColor = UIColor.grayColor()
        self.configView.alpha = 0.0
        // Do any additional setup after loading the view, typically from a nib.
    
        appConfig(defaultValues: ["test":"test"])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconVisible:", name: "beaconVisible", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconDisappeared:", name: "beaconDisappeared", object: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // Any beacon marks home at this point.
        regionLabel.textColor = UIColor.redColor()
        for (currBeacon: beacon, state: Int) in appDelegate.hBeacon!.beaconDictionary {
            if state == 1 {
                regionLabel.textColor = UIColor.greenColor()
            }
        }
    }

    func beaconVisible(notification: NSNotification) {
        connected = true
        regionLabel.textColor = UIColor.greenColor()
        NSLog("welcome to: \((notification.object as beacon).identifier)")
    }
    
    func beaconDisappeared(notification: NSNotification) {
        connected = false
        regionLabel.textColor = UIColor.redColor()
        NSLog("by by to: \((notification.object as beacon).identifier)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.configView.alpha = 0.0
        self.regionLabel.text = appConfig().params["region"]
        self.userText.text = appConfig().params["username"]
        self.serverText.text = appConfig().params["server"]
        self.portText.text = appConfig().params["port"]
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: .CurveEaseInOut,
            animations: {
                self.configView.alpha = 1.0
                self.configView.hidden = false
            },
            completion: { finished in }
        )
    }
    
    override func viewDidDisappear(animated: Bool) {
        var userDefaults = NSUserDefaults()
        appConfig().update("username", value: userText.text)
        appConfig().update("server", value: serverText.text)
        appConfig().update("port", value: portText.text)
    
        // appConfig().debug()
    }

    @IBOutlet weak var configView: UIView!

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var portText: UITextField!
    @IBOutlet weak var serverText: UITextField!
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        appConfig().update("username", value: userText.text)
        appConfig().update("server", value: serverText.text)
        appConfig().update("port", value: portText.text)
    }
    
}

