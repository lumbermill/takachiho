//
//  TitleScene.swift
//  sandbox-game03
//
//  Created by ItoYosei on 10/11/15.
//  Copyright © 2015 LumberMill, Inc. All rights reserved.
//

import SpriteKit
import GameKit

class TitleScene: SKScene, GKGameCenterControllerDelegate {
    let level_names = ["Easy","Medium","Hard"]
    let levels = ["Easy":11,"Medium":25,"Hard":37]
    
    override func didMoveToView(view: SKView) {
        self.removeAllChildren()
        authPlayer()
        
        let x = CGRectGetMidX(self.frame)
        var y = CGRectGetMidY(self.frame) + 96
        let title = SKLabelNode(text: "Maze")
        title.fontSize = 65
        title.fontColor = SKColor.grayColor()
        title.position = CGPointMake(x,y);
        self.addChild(title)
        
        y -= 96
        let hiscore = SKLabelNode(text: "Hiscore")
        hiscore.fontSize = 20
        hiscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        hiscore.position = CGPointMake(x+32, y)
        hiscore.name = "hiscore"
        self.addChild(hiscore)
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        y -= 32
        for l in level_names{
            let score = ud.integerForKey(l.lowercaseString+".hiscore")
            let b = SKLabelNode(text: l)
            b.fontSize = 32
            b.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            b.position = CGPointMake(x-32, y)
            b.name = l
            let s = SKLabelNode(text: String(format: "%.2f", arguments: [score > 0 ? Double(score) / 100.0 : 999.99]))
            s.fontSize = 20
            s.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            s.fontColor = title.fontColor
            s.position = CGPointMake(x+32, y)
            y -= 84
            self.addChild(b)
            self.addChild(s)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches{
            for l in levels.keys{
                if let node = self.childNodeWithName(l){
                    if(CGRectContainsPoint(node.frame, t.locationInNode(self))){
                        transitToGameScene(node)
                    }
                }
            }
            if let node = self.childNodeWithName("hiscore"){
                if(CGRectContainsPoint(node.frame, t.locationInNode(self))){
                    showScore()
                }
            }
        }
    }
    
    func transitToGameScene(level: SKNode){
        if let s = scenes["game"] as! GameScene?{
            if let v = self.view{
                level.runAction(SKAction.fadeAlphaTo(0.3, duration: 0.1))
                let message = SKLabelNode(text: "Generating the maze..")
                message.fontSize = 18
                message.fontColor = SKColor.grayColor()
                let x = CGRectGetMidX(self.frame)
                let y = CGRectGetMidY(self.frame) + 32.0
                message.position = CGPointMake(x,y);
                self.addChild(message)

                s.level = level.name!.lowercaseString
                s.mazeSize = levels[level.name!]!
                
                let p = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(p, 0), {
                    s.generate()
                    dispatch_async(dispatch_get_main_queue(), {
                        message.removeFromParent()
                        let t = SKTransition.crossFadeWithDuration(0.5)
                        v.presentScene(s,transition: t)
                    })
                })
            }
        }
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