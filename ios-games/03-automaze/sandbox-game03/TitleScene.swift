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
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        authPlayer()
        
        let x = self.frame.midX
        var y = self.frame.midY + 96
        let title = SKLabelNode(text: "Maze")
        title.fontSize = 65
        title.fontColor = SKColor.gray
        title.position = CGPoint(x:x,y:y);
        self.addChild(title)
        
        y -= 96
        let hiscore = SKLabelNode(text: "Hiscore")
        hiscore.fontSize = 20
        hiscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        hiscore.position = CGPoint(x:x+32,y:y)
        hiscore.name = "hiscore"
        self.addChild(hiscore)
        
        let ud = UserDefaults.standard
        
        y -= 32
        for l in level_names{
            let score = ud.integer(forKey: l.lowercased()+".hiscore")
            let b = SKLabelNode(text: l)
            b.fontSize = 32
            b.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            b.position = CGPoint(x:x-32,y:y)
            b.name = l
            let s = SKLabelNode(text: String(format: "%.2f", arguments: [score > 0 ? Double(score) / 100.0 : 999.99]))
            s.fontSize = 20
            s.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            s.fontColor = title.fontColor
            s.position = CGPoint(x:x+32,y:y)
            y -= 84
            self.addChild(b)
            self.addChild(s)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            for l in levels.keys{
                if let node = self.childNode(withName: l){
                    if(node.frame.contains(t.location(in: self))){
                        transitToGameScene(level: node)
                    }
                }
            }
            if let node = self.childNode(withName: "hiscore"){
                if(node.frame.contains(t.location(in: self))){
                    showScore()
                }
            }
        }
    }
    
    func transitToGameScene(level: SKNode){
        if let s = scenes["game"] as! GameScene?{
            if let v = self.view{
                level.run(SKAction.fadeAlpha(to: 0.3, duration: 0.1))
                let message = SKLabelNode(text: "Generating the maze..")
                message.fontSize = 18
                message.fontColor = SKColor.gray
                let x = self.frame.midX
                let y = self.frame.midY + 32.0
                message.position = CGPoint(x:x,y:y);
                self.addChild(message)

                s.level = level.name!.lowercased()
                s.mazeSize = levels[level.name!]!
                
                DispatchQueue.global().async {
                    s.generate()
                    DispatchQueue.main.async {
                        message.removeFromParent()
                        let t = SKTransition.crossFade(withDuration: 0.5)
                        v.presentScene(s,transition: t)
                    }
                }
            }
        }
    }
    
    func authPlayer(){
        let p = GKLocalPlayer.local
        p.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil){
                if let vc = UIApplication.shared.delegate?.window??.rootViewController {
                    vc.present(viewController!, animated: true, completion: nil)
                }
            } else {
                print("%d",GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    func showScore(){
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
