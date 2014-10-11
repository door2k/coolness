//
//  FirstViewController.swift
//  coolness
//
//  Created by Tamir Berliner on 10/1/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var appName: UILabel!
    //@IBOutlet weak var playPauseButton: UIButton!
//    var forgroundApp: String?
    
    @IBOutlet weak var appImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appImage.image = UIImage(named: "VLC_icon")
        self.appImage.viewForBaselineLayout()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeWindow:", name: "ActiveWindow", object: nil)
        network().getActiveWindow()
    }

    func activeWindow(notification: NSNotification) {
        NSLog(notification.object as NSString)
        dispatch_async(dispatch_get_main_queue(), {
            let appNameFromNotification = (notification.object as? NSString)
            if  appNameFromNotification != "" {
                self.appName!.text = appNameFromNotification
            }
        })
        network().getActiveWindow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum PlayState {
        case Playing
        case Paused
    }
    
    var mediaState: PlayState = .Paused
    
    @IBAction func buttonClicked(sender : AnyObject) {
        if (mediaState == .Paused) {
            (sender as UIButton).setImage(UIImage(named: "media-pause-8x"), forState: .Normal)
            mediaState = .Playing
            network().sendCommand("Play")
        } else {
            (sender as UIButton).setImage(UIImage(named: "media-play-8x"), forState: .Normal)
            mediaState = .Paused
            network().sendCommand("Pause")
        }
        
        return
    }
}