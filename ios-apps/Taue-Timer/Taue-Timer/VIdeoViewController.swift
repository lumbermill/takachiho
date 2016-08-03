//
//  ViewController.swift
//  Taue-Timer
//
//  Created by koki on 2016/08/03.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class VideoViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().pathForResource("Taue-Movie", ofType: "mp4")!
        let videoURL = NSURL(fileURLWithPath: path)
        self.player = AVPlayer(URL: videoURL)
        player?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

