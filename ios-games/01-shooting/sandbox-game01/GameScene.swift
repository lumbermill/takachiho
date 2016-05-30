//
//  GameScene.swift
//  sandbox-game01
//
//  Created by ItoYosei on 10/3/15.
//  Copyright (c) 2015 LumberMill, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var ball = SKSpriteNode(imageNamed: "ball")
    var boar = SKSpriteNode(imageNamed: "boar")
    var power = SKSpriteNode(imageNamed: "power")
    var aim = SKSpriteNode(imageNamed: "aim")
    var hit = SKAction.playSoundFileNamed("se_maoudamashii_system44.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.9);
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        ball.position = CGPoint(x:CGRectGetMidX(self.frame), y:ball.size.height);
        ball.size = CGSize(width: 64, height: 64)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody!.dynamic = true
        ball.physicsBody!.restitution = 1.0
        self.addChild(ball)
        
        
        // 背景用意するまでとりあえず。
        let ground:SKSpriteNode = SKSpriteNode(color:SKColor.brownColor(),size:CGSize(width: self.frame.width, height: 30))
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y:5)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody!.dynamic = false;
        ground.name = "ground"
        ground.physicsBody?.restitution = 1.0
        self.addChild(ground)
        
        let ceiling:SKSpriteNode = SKSpriteNode(color:SKColor.brownColor(),size:CGSize(width: self.frame.width, height: 30))
        ceiling.position = CGPoint(x: CGRectGetMidX(self.frame), y:self.frame.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: ceiling.size)
        ceiling.physicsBody!.dynamic = false;
        ceiling.name = "ceiling"
        ground.physicsBody?.restitution = 0.5
        self.addChild(ceiling)
        
        let l_wall:SKSpriteNode = SKSpriteNode(color:SKColor.brownColor(),size:CGSize(width: 10, height: self.frame.height))
        l_wall.position = CGPoint(x: 0, y:CGRectGetMidY(self.frame))
        l_wall.physicsBody = SKPhysicsBody(rectangleOfSize: l_wall.size)
        l_wall.physicsBody!.dynamic = false;
        l_wall.name = "l_wall"
        self.addChild(l_wall)
        
        let r_wall:SKSpriteNode = SKSpriteNode(color:SKColor.brownColor(),size:CGSize(width: 10, height: self.frame.height))
        r_wall.position = CGPoint(x: self.frame.width, y:CGRectGetMidY(self.frame))
        r_wall.physicsBody = SKPhysicsBody(rectangleOfSize: r_wall.size)
        r_wall.physicsBody!.dynamic = false;
        r_wall.name = "r_wall"
        self.addChild(r_wall)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        power.size = CGSize(width: 1, height: 36)
        power.position = CGPoint(x:CGRectGetMidX(self.frame), y:power.size.height)
        let expand = SKAction.resizeToWidth(240, duration: 1.0)
        let shrink = SKAction.resizeToWidth(10, duration: 1.0)
        let es = SKAction.sequence([expand, shrink])
        power.runAction(SKAction.repeatActionForever(es))
        
        aim.position = CGPoint(x:CGRectGetMidX(self.frame), y:0)
        aim.anchorPoint = CGPoint(x:0.5,y:0.0)
        
        self.addChild(aim)
        self.addChild(power)

    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        
        
        let dx = location.x - self.frame.width / 2
        let dy = location.y
        let theta = -atan(dx / dy)
        aim.zRotation = theta
        NSLog("rotate = %f", theta)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 強さを決定
        let p = power.size.width / 5
        // 向きは真上が0で左に正、右に負のラジアン
        let r = aim.zRotation
        aim.removeFromParent()
        power.removeFromParent()
        self.runAction(hit)
        
        let dx = -p * sin(r)
        let dy = p * cos(r)
        NSLog("power = %f, r = %f v = (%f,%f)", p,r,dx,dy)
        ball.physicsBody?.velocity.dx = dx * p;
        ball.physicsBody?.velocity.dy = dy * p;
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
