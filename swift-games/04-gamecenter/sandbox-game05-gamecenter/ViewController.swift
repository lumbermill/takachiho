//
//  ViewController.swift
//  sandbox-game05-gamecenter
//
//  Created by ItoYosei on 11/15/15.
//  Copyright © 2015 LumberMill, Inc. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, GKGameCenterControllerDelegate {

    var score = 0
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        authPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addScore(sender: AnyObject) {
        score += 1
        scoreLabel.text = String(score)
    }

    @IBAction func reportScore(sender: AnyObject) {
        reportScore()
        score = 0
    }
    
    @IBAction func showScore(sender: AnyObject) {
        showScore()
    }
    
    func authPlayer(){
        let p = GKLocalPlayer.localPlayer()
        p.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil){
                if let vc = UIApplication.sharedApplication().delegate?.window??.rootViewController {
                    vc.presentViewController(viewController!, animated: true, completion: nil)
                }
            } else {
                NSLog("%d",GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }

    func reportScore(){
        if (!GKLocalPlayer.localPlayer().authenticated) { return }
        let s = GKScore(leaderboardIdentifier: "test") // Leaderboard ID
        s.value = Int64(score)
        NSLog("Reporting scores %@",s)
        GKScore.reportScores([s], withCompletionHandler: {(error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
        })
    }
    
    func showScore(){
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

