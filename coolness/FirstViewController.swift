//
//  FirstViewController.swift
//  coolness
//
//  Created by Tamir Berliner on 10/1/14.
//  Copyright (c) 2014 Tamir Berliner. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //var x_origin = self.view.bounds.width/2
        //let new_rect = CGRect(origin: CGPoint(x: x_origin, y: 417), size: CGSize(width: 50,height: 50))
        //NSLog("\(new_rect.width)")
        //self.playPauseButton.alignmentRectForFrame(new_rect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getURL(command: String) -> NSURL {
        return NSURL(string: "http://10.0.0.47:5000/send_key?action=\(command)")
    }
    
    func sendCommand(command: String) {
        let url:NSURL = getURL(command)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    enum PlayState {
        case Playing
        case Paused
    }
    
    var mediaState: PlayState = .Paused
    
    @IBAction func buttonClicked(sender : AnyObject) {
//        (sender as UIButton).imageEdgeInsets(<#title: String?#>, forState: <#UIControlState#>) UIEdgeInsetsMake(top, left, bottom, right)
        if (mediaState == .Paused) {
            (sender as UIButton).setImage(UIImage(named: "media-pause-8x"), forState: .Normal)
            mediaState = .Playing
        } else {
            (sender as UIButton).setImage(UIImage(named: "media-play-8x"), forState: .Normal)
            mediaState = .Paused
        }
        
        return
    }
}