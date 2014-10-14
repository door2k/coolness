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
    
    @IBOutlet weak var volumeSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeWindow:", name: "ActiveWindow", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeUpdate:", name: "VolumeUpdate", object: nil)
        network().getActiveWindow()
        //network().getVolume()
    }

    func activeWindow(notification: NSNotification) {
//        NSLog(notification.object as NSString)
        dispatch_async(dispatch_get_main_queue(), {
            let appNameFromNotification = (notification.object as? NSString)
            if  appNameFromNotification != "" {
                self.appName!.text = appNameFromNotification
            }
            if appNameFromNotification == "VLC" {
                self.appImage.image = UIImage(named: "VLC_icon.png")
                
                self.appImage.contentMode = UIViewContentMode.ScaleAspectFit;
                self.appImage.clipsToBounds = true;
            } else {
                self.appImage.image = nil
            }
        })
        network().getActiveWindow()
    }
    
    func volumeUpdate(notification: NSNotification) {
        NSLog(notification.object as NSString)
        dispatch_async(dispatch_get_main_queue(), {
            let volume:Float = (notification.object as NSString).floatValue
            self.volumeSlider.value = volume
        })
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
    
    @IBAction func sliderChanged(sender: AnyObject) {
        network().setVolume(self.volumeSlider.value)
        NSLog("volume: \(self.volumeSlider.value)")
    }
    
}