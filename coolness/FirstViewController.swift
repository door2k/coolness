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
    @IBOutlet weak var playPauseButton: UIButton!
//    var forgroundApp: String?
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var appImage: UIImageView!
    
    @IBOutlet weak var volumeSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activeApp:", name: "ActiveApp", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeUpdate:", name: "VolumeUpdate", object: nil)
    }

    var activeApp: CNRemoteApp? = nil
    
    func activeApp(notification: NSNotification) {
        let app = (notification.object as? CNRemoteApp)
        
        activeApp = app
        
        dispatch_async(dispatch_get_main_queue(), {
            self.appName.text = app?.name
            self.appImage.image = app?.icon
            self.appImage.contentMode = UIViewContentMode.ScaleAspectFit;
            self.appImage.clipsToBounds = true;
            
            self.playPauseButton.enabled = app!.remote.supports(CNAppCapabilities.Play)
            
            self.fullScreenButton.enabled = app!.remote.supports(CNAppCapabilities.FullScreen)
        })
        
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
    
    var isFullScreen: Bool = false
    
    @IBAction func fullScreenClicked(sender: AnyObject) {
        if (activeApp == nil) {
            return
        }
        
        if (isFullScreen) {
            (sender as UIButton).setImage(UIImage(named: "toFullScreen"), forState: .Normal)
            isFullScreen = false
        } else {
            (sender as UIButton).setImage(UIImage(named: "fromFullScreen"), forState: .Normal)
            isFullScreen = true
        }
        activeApp!.remote.useCapability(CNAppCapabilities.FullScreen)
        return

    }
    @IBAction func sliderChanged(sender: AnyObject) {
        network().setVolume(self.volumeSlider.value)
        NSLog("volume: \(self.volumeSlider.value)")
    }
    
}