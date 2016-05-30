//
//  GameScene.swift
//  sandbox-game02
//
//  Created by ItoYosei on 10/4/15.
//  Copyright (c) 2015 LumberMill, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    enum Phase {
        case GetReady, Game, GameOver, Medal
    }
    
    
    // ball
    let BOAT_WIDTH : CGFloat = 36.0
    let GRAVITY : CGFloat = -9.8 * 0.7 // 0.9
    let BOAT_VELOCITY_Y : CGFloat = 260.0 // 390.0
    
    let HOLE_HEIGHT : CGFloat = 160.0 //120.0
    let HOLE_Y_MAX : UInt32 = 480
    let HOLE_Y_MIN : UInt32 = 60
    let SPEED_OBSTACLES :CGFloat = 100.0
    let INTERVAL_BETWEEN_OBSTACLES = 1.8
    
    // wall
//    let kWallHeightUnit : CGFloat = 480.0 / 13.0
//    let kHoleHeight : UInt32 = 3
//    let kUpperWallHeightMin : UInt32 = 2
//    let kUpperWallHeightMax : UInt32 = 8
    //let kWallSpeed : CGFloat = 320.0 / 3.0
    
    var phase = Phase.GetReady
    var points = 0
    var timeForWallGoThroughBall : NSTimeInterval = 0.0
    
    let obstacleTexture = SKTexture(imageNamed: "obstacle")
    var boat = SKSpriteNode(imageNamed: "boat1")
    var label = SKLabelNode(fontNamed:"AmericanTypewriter-Bold")

    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0x26 / 255.0, green: 0xa1 / 255.0, blue: 0x96 / 255.0, alpha: 1.0)
        timeForWallGoThroughBall = NSTimeInterval(self.size.width / SPEED_OBSTACLES * 0.75)
        
        getReady()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch phase {
        case .Game:
            boat.physicsBody!.velocity.dy = BOAT_VELOCITY_Y
        case .Medal:
            if self.childNodeWithName("cover") == nil {
                goBackToGetReady()
            }
        case .GetReady:
            startGame()
        default:
            print(phase)
            print("unknown phase.")
        }
    }
    
    func putBoat(){
        boat.position = CGPointMake(self.frame.size.width / 4.0, self.frame.size.height / 2.0)
        NSLog("position=(%d,%d) ",boat.position.x,boat.position.y)
        boat.hidden = false
        boat.name = "boat"
        boat.zRotation = 0.0
        boat.size = CGSize(width: BOAT_WIDTH, height: BOAT_WIDTH)
        boat.physicsBody = SKPhysicsBody(circleOfRadius:BOAT_WIDTH / 2.0)
        
        let sp = SKAction.animateWithTextures([SKTexture(imageNamed: "boat1.png"),SKTexture(imageNamed: "boat2.png")], timePerFrame: 0.25)
        boat.runAction(SKAction.repeatActionForever(sp))
        
        self.addChild(boat)
    }

    func putWall()
    {
        let wallTexture = SKTexture(imageNamed: "wall")
        
        let size = CGSizeMake(self.size.width * 2.0, wallTexture.size().height)
        
        let floor = SKSpriteNode(texture:wallTexture)
        floor.size = size
        floor.position = CGPointMake(self.size.width, size.height * 0.5)
        floor.name = "wall"
        floor.zPosition = 4000
        
        let body = SKPhysicsBody(rectangleOfSize:size)
        body.affectedByGravity = false
        body.dynamic = false
        body.contactTestBitMask = 1
        body.linearDamping = 0.0
        floor.physicsBody = body
        
        let sequence = SKAction.sequence([
            SKAction.moveToX(0.0, duration:NSTimeInterval(self.size.width / SPEED_OBSTACLES)),
            SKAction.moveToX(self.size.width, duration:0.0)])
        let action = SKAction.repeatActionForever(sequence)
        floor.runAction(action)
        
        self.addChild(floor)
    }

    func getReady()
    {
        putBoat()
        boat.physicsBody!.affectedByGravity = false
        let up = SKAction.moveBy(CGVectorMake(0.0,BOAT_WIDTH), duration: 0.4)
        up.timingMode = .EaseOut
        let down = SKAction.moveBy(CGVectorMake(0.0, -BOAT_WIDTH), duration: 0.35)
        down.timingMode = .EaseIn
        let sequence = SKAction.sequence([up, down])
        let action = SKAction.repeatActionForever(sequence)
        boat.runAction(action)
    
        putWall()
        
        phase = Phase.GetReady
    }

    func startGame()
    {
        phase = Phase.Game
        boat.removeFromParent()
        
        self.physicsWorld.gravity = CGVectorMake(0.0, GRAVITY)
        self.physicsWorld.contactDelegate = self
        
        putBoat()
        putObstaclesPeriodically()
        putPointsLabel()
        
        points = 0
    }


    func goBackToGetReady()
    {
        let children = self.children
        let cover = SKSpriteNode(color: UIColor.blackColor(), size:self.size)
        cover.alpha = 0.0
        cover.name = "cover"
        cover.position = CGPointMake(self.size.width/2.0, self.size.height/2.0)
        cover.zPosition = 100000
        self.addChild(cover)
        
        cover.runAction(SKAction.sequence([
            SKAction.fadeInWithDuration(0.3),
            SKAction.runBlock({
                self.removeChildrenInArray(children)
                self.getReady() }),
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()
            ]))
    }

    func putObstaclesPeriodically()
    {
        let pointAction = SKAction.sequence([
            SKAction.waitForDuration(timeForWallGoThroughBall),
            SKAction.runBlock({
                
                if self.boat.position.y > self.size.height {
                    self.gameOver()
                }
                else {
                    self.incrementPoints()
                }
            })
            ])
        
        self.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(INTERVAL_BETWEEN_OBSTACLES),
                    SKAction.runBlock({
                        self.putObstacles()
                        self.runAction(pointAction)
                    })])
            ))
    }
    
    func putObstacleWithY(y:CGFloat)
    {
        let w = obstacleTexture.size().width
        let wall = SKSpriteNode(texture: obstacleTexture, size:obstacleTexture.size())
        wall.position = CGPointMake(self.size.width + w / 2.0, y)
        
        let body = SKPhysicsBody(rectangleOfSize:wall.size)
        body.affectedByGravity = false
        body.dynamic = false
        body.contactTestBitMask = 1
        wall.physicsBody = body
        
        wall.runAction(
            SKAction.sequence([
                SKAction.moveToX(-w, duration:NSTimeInterval((self.size.width + w) / SPEED_OBSTACLES)),
                SKAction.removeFromParent()]))
        
        self.addChild(wall)
    }

    func putObstacles()
    {
        arc4random()
        let holeY = CGFloat(arc4random() % (HOLE_Y_MAX - HOLE_Y_MIN) + HOLE_Y_MIN)
        
        let h = obstacleTexture.size().height
        putObstacleWithY(holeY - (HOLE_HEIGHT + h) / 2)
        putObstacleWithY(holeY + (HOLE_HEIGHT + h) / 2)
    }

    
    func incrementPoints()
    {
        let label = self.childNodeWithName("points") as! SKLabelNode
        label.text = String(++points)
    }

    func putGameOverLabel() {
        let label = SKLabelNode(fontNamed:"AmericanTypewriter-Bold")
        label.fontSize = 36.0
        label.fontColor = UIColor.blackColor()
        label.text = "Game Over"
        label.zPosition = 5000
        label.position = CGPointMake(self.size.width/2, self.size.height-36.0)
        
        let moveToAction = SKAction.moveToY(self.size.height/2.0, duration: 0.1)
        let blockAction = SKAction.runBlock({ self.phase = Phase.Medal })
        label.runAction(SKAction.sequence([moveToAction, blockAction]))
        
        self.addChild(label)
    }

    func gameOver()
    {
        self.removeAllActions()
        for node : AnyObject in self.children {
            node.removeAllActions()
        }
        putGameOverLabel()
        phase = Phase.GameOver
    }

    
    func putPointsLabel()
    {
        label.name = "points"
        label.fontSize = 36.0
        label.fontColor = UIColor.orangeColor()
        label.text = "0"
        label.position = CGPointMake(self.size.width / 2.0, self.size.height * 0.75)
        label.zPosition = 5000
        self.addChild(label)
    }


   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        if phase == Phase.Game {
            gameOver()
        }
    }

}
