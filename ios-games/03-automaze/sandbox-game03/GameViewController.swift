//
//  GameViewController.swift
//  sandbox-game03
//
//  Created by ItoYosei on 10/4/15.
//  Copyright (c) 2015 LumberMill, Inc. All rights reserved.
//

import UIKit
import SpriteKit

var scenes = [String:SKScene]();

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scenes["title"] = TitleScene()
        scenes["game"] = GameScene()
        
        for key in scenes.keys{
            if let s:SKScene = scenes[key] {
                s.scaleMode = .AspectFit
                s.size = CGSize(width: 375, height: 500)
                // TODO: How to disable muititouch?
            }
        }

        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        skView.presentScene(scenes["title"]!)

    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
