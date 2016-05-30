//
//  GameScene.swift
//  sandbox-gamesize
//
//  Created by ItoYosei on 10/6/15.
//  Copyright (c) 2015 LumberMill, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    func toString(size: CGSize) -> String {
        return String(format: "w:%.1f, h:%.1f", arguments: [size.width,size.height]);
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let MARGIN: CGFloat = 50.0
        
        let s = CGSize(width: self.frame.size.width - MARGIN * 2, height: self.frame.size.height - MARGIN * 2)
        let r = SKSpriteNode(color: UIColor.grayColor(), size: s)
        r.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(r)
        
        let l1 = SKLabelNode(fontNamed:"Papyrus")
        l1.fontSize = 32;
        l1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 16);
        l1.text = "self.frame: "+toString(self.frame.size)

        let l2 = SKLabelNode(fontNamed:"Papyrus")
        l2.fontSize = 32;
        l2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 16);
        l2.text = "self: " + toString(self.size)

        self.addChild(l1)
        self.addChild(l2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
