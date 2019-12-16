//
//  GameScene.swift
//  sandbox-game03
//
//  Created by ItoYosei on 10/4/15.
//  Copyright (c) 2015 LumberMill, Inc. All rights reserved.
//

import SpriteKit
import GameKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    var rows : Array<Array<Int>> = []
    var blockColor = UIColor.gray
    var level = "" // レベル easy, medium, hard
    var mazeSize = 31 // 迷路短辺のブロック数
    
    // generate内で計算されます
    var blockSize:Int = 0
    // numberOfCols always equals to mazeSize.
    var numberOfRows:Int = 0
    var xOffset:CGFloat = 0
    var yOffset:CGFloat = 0
    
    var status = 0 // 0:not yet started. 1:gaming 2:reached to goal
    var started:TimeInterval = 0.0
    
    let mm = CMMotionManager()
    
    let CAT_BALL:UInt32 = 0x1 << 0
    let CAT_GOAL:UInt32 = 0x1 << 1
    
    var timer:SKLabelNode!
    var audioPlayer:AVAudioPlayer!

    override func didMove(to view: SKView) {
        // ブロックを配置
        for i in 0..<numberOfRows {
            for j in 0..<mazeSize {
                if rows[i][j] == 1{
                    putBlock(row: i, j)
                }
            }
        }
        
        if self.childNode(withName: "title") == nil {
            // 戻るボタン
            let b = SKLabelNode(text: "< Back to Title")
            b.fontSize = 16
            b.position = CGPoint(x: b.frame.size.width / 2 + 12,y: 0)
            b.name = "title"
            self.addChild(b)
            
            timer = SKLabelNode(text: "000.00")
            timer.fontSize = 16
            timer.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            timer.position = CGPoint(x: frame.size.width - timer.frame.size.width - 12,y: 0)
            timer.name = "time"
            self.addChild(timer)
        }
        if let b = self.childNode(withName: "ball") {
            b.removeFromParent()
        }
        // 音の準備
        prepareSound(name: "se_maoudamashii_se_sound11")
        
        self.physicsWorld.gravity = CGVector(dx: 0,dy: -9.8)
        self.physicsWorld.contactDelegate = self
        
        let wait = TimeInterval((numberOfRows) * mazeSize / 500)
        self.run(SKAction.wait(forDuration: wait), completion: {
            // ボール
            let r = CGFloat(self.blockSize) * 0.95 / 2.0
            let ball = SKShapeNode(circleOfRadius: r)
            ball.position = self.CGPointFromPoint(self.numberOfRows - 3, 2)
            ball.fillColor = UIColor.orange
            ball.lineWidth = 0
            ball.name = "ball"
            ball.xScale = 3.0
            ball.yScale = 3.0
            ball.run(SKAction.scale(to: 1.0, duration: 0.4), completion: {
                ball.physicsBody = SKPhysicsBody(circleOfRadius: r)
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.categoryBitMask = self.CAT_BALL
                ball.physicsBody?.contactTestBitMask = self.CAT_GOAL
            })
            self.addChild(ball)
            
            // ゴール
            let w = SKAction.wait(forDuration: 1 / 500.0)
            self.putBlock(1, self.mazeSize - 3,color: UIColor.blue,wait:w)

            // 加速度センサ
            let cq = OperationQueue.current
            let h = {(data:CMAccelerometerData?, error:Error?) -> Void in
                if let d = data {
                    //NSLog("x,y,z = %.1f,%.1f,%.1f,",d.acceleration.x,d.acceleration.y, d.acceleration.z)
                    let G = 18.0
                    let dx = CGFloat(d.acceleration.x * G)
                    let dy = CGFloat(d.acceleration.y * G)
                    self.physicsWorld.gravity = CGVector(dx:dx,dy:dy)
                }
            }
            self.mm.accelerometerUpdateInterval = 0.1
            self.mm.startAccelerometerUpdates(to: cq!, withHandler: h)
            
            // 音
            self.audioPlayer.play()
            
            self.started = NSDate.timeIntervalSinceReferenceDate
            self.status = 1 // started
        })
    }
    
    func prepareSound(name: String) {
        let sound_path = Bundle.main.path(forResource: name, ofType: "mp3")!
        let sound_url = NSURL(fileURLWithPath: sound_path)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: sound_url as URL)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }catch{
            NSLog("Failed to play sound.");
        }
    }
    
    override func willMove(from view: SKView) {
        // 加速度センサを止める
        mm.stopAccelerometerUpdates()
        // 開始時刻をリセット
        started = 0.0
        status = 0
        // 不要なノードを消す
        for name in ["ball","goal","retry","score"] {
            if let node = self.childNode(withName: name) {
                node.removeFromParent()
            }
        }
    }
    
    func nameFromPoint(_ row: Int,_ col :Int) -> String{
        return String(format: "b-%03d,%03d", arguments: [row,col])
    }
    
    func CGPointFromPoint(_ row: Int,_ col: Int) -> CGPoint{
        let y = CGFloat(row * blockSize)
        let x = CGFloat(col * blockSize)
        
        return CGPoint(x: x + xOffset, y: y + yOffset)
    }

    func putBlock(row: Int,_ col: Int){
        let w = SKAction.wait(forDuration: TimeInterval(row * mazeSize + col) / 500.0)
        putBlock(row,col,color: blockColor,wait:w)
    }

    func putBlock(_ row: Int,_ col: Int, color: UIColor,wait: SKAction){
        rows[row][col] = 1
        let name = nameFromPoint(row, col)
        if self.childNode(withName: name) != nil{
            return;
        }
        let b = SKSpriteNode(color: color , size: CGSize(width: blockSize, height: blockSize))
        b.position = CGPointFromPoint(row,col)
        b.name = name
        b.xScale = 1.5
        b.yScale = 1.5
        b.alpha = 0.0
        b.physicsBody = SKPhysicsBody(rectangleOf: b.size)
        b.physicsBody?.isDynamic = false
        if(color == UIColor.blue){
            b.physicsBody?.categoryBitMask = CAT_GOAL
            b.physicsBody?.contactTestBitMask = CAT_BALL
        }
        b.run(SKAction.sequence([wait,SKAction.scale(to: 1.0, duration: 0.5)]))
        b.run(SKAction.sequence([wait,SKAction.fadeAlpha(to: 1.0, duration: 0.5)]))
        self.addChild(b)
    }
    
    
    func dig(_ row: Int,_ col: Int){
        var crow = row
        var ccol = col
        while true{
            var targets = [Int]()
            if rows[crow+2][ccol] == 1 { targets.append(0) }
            if rows[crow][ccol+2] == 1 { targets.append(1) }
            if rows[crow-2][ccol] == 1 { targets.append(2) }
            if rows[crow][ccol-2] == 1 { targets.append(3) }
            
            // 行き先が無くなったら終了
            if targets.count == 0 { break }

            var trow1 = crow
            var tcol1 = ccol
            var trow2 = crow
            var tcol2 = ccol
            let d = targets[Int(arc4random() % UInt32(targets.count))]
            switch d{
            case 0:
                trow1 += 1
                trow2 += 2
            case 1:
                tcol1 += 1
                tcol2 += 2
            case 2:
                trow1 -= 1
                trow2 -= 2
            case 3:
                tcol1 -= 1
                tcol2 -= 2
            default:
                NSLog("Invalid")
            }
            
            rows[trow1][tcol1] = 0
            rows[trow2][tcol2] = 0
            crow = trow2
            ccol = tcol2
        }
    }
    
    func generate(){
        // 全部クリア
        for c in self.children{
            if let n = c.name {
                if(n.hasPrefix("b-")){
                    c.removeFromParent()
                }
            }
        }
        
        let N_COL = mazeSize
        let N_ROW = mazeSize / 3 * 4 + 1
        assert(N_ROW % 2 == 1,  "Must be odd number.")
        assert(N_COL % 2 == 1, "Must be odd number.")

        numberOfRows = N_ROW
        blockSize = Int(self.frame.size.width) / N_COL
        assert(blockSize > 0, "Maze size is too big.")
        xOffset = (self.frame.size.width - CGFloat(blockSize * N_COL)) / 2.0
            + CGFloat(blockSize) / 2.0
        yOffset = (self.frame.size.height - CGFloat(blockSize * N_ROW)) / 2.0
            + CGFloat(blockSize) / 2.0
        
        rows = [[Int]]()
        
        for i in 0..<N_ROW {
            var cols = [Int]()
            for j in 0..<N_COL {
                if i == 0 || i == N_ROW - 1 {
                    cols.append(0)
                }else if j == 0 || j == N_COL - 1 {
                    cols.append(0)
                }else{
                    cols.append(1)
                }
            }
            rows.append(cols)
        }

        rows[1][N_COL - 3] = 0
        rows[N_ROW - 3][2] = 0
        
        dig(N_ROW - 3, 2)
        while true{
            for i in 2...N_ROW-3 {
                for j in 2...N_COL-3 {
                    if i % 2 == 1 || j % 2 == 1 { continue }
                    // 偶数ますのみ
                    if rows[i][j] == 0 {
                        dig(i, j)
                    }
                }
            }
            if rows[2][N_COL - 3] == 0 { break }
        }
    }
    
    func touched(touches: Set<UITouch>,node: SKNode?) -> Bool{
        if node != nil {
            for t in touches{
                if(node!.frame.contains(t.location(in: self))){
                    return true
                }
            }
        }
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(status == 0) { return }
        if touched(touches: touches,node: self.childNode(withName: "title")){
            // タイトルに戻る
            transitToTitleScene()
        }else if touched(touches: touches,node: self.childNode(withName: "retry")){
            self.willMove(from: self.view!)
            self.generate()
            self.didMove(to: self.view!)
        }
    }

    func transitToTitleScene(){
        if let s = scenes["title"] as! TitleScene?{
            if let v = self.view{
                let t = SKTransition.crossFade(withDuration: 0.5)
                v.presentScene(s,transition:t)
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let b = contact.bodyA.categoryBitMask & contact.bodyB.categoryBitMask
        if (b == (CAT_GOAL & CAT_BALL)) {
            NSLog("Goal!")
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()

            self.audioPlayer.play()

            // TODO: パーティクル
            
            // タイマー止める
            started = 0.0
            status = 2
            // ゴールの文字を出す。 スコアを見る リトライ

            let x = self.frame.midX
            var y = self.frame.midY + 32
            
            var elapsed:Int = 99999
            if let t = self.childNode(withName: "time") as! SKLabelNode?{
                elapsed = Int(Double(t.text!)! * 100)
            }
            let ud = UserDefaults.standard
            let last_elapsed = ud.integer(forKey: level+".hiscore")
            
            let goal = SKLabelNode(text: elapsed < last_elapsed ? "Great!!" : "Goal!")
            goal.fontSize = 48
            goal.xScale = 10.0
            goal.xScale = 5.0
            goal.position = CGPoint(x:x,y:y)
            goal.name = "goal"
            
            y -= 64
            let retry = SKLabelNode(text: "Retry")
            retry.fontSize = 24
            retry.position = CGPoint(x: x, y:y)
            retry.name = "retry"

            self.addChild(goal)
            self.addChild(retry)
            
            let a = SKAction.scale(to: 1.0, duration: 0.4)
            goal.run(a)
            
            if last_elapsed == 0 || elapsed < last_elapsed {
                // Stores to local.
                ud.set(elapsed, forKey: level+".hiscore")
                
            }
            reportScore(elapsed: elapsed)
        }
    }

    func reportScore(elapsed: Int){
        // unless it is highest score(minimum time), do nothing.
        // Send Game Center
        if (!GKLocalPlayer.local.isAuthenticated) { return }
        let s = GKScore(leaderboardIdentifier: "grp.automaze."+level)
        s.value = Int64(elapsed)
        GKScore.report([s], withCompletionHandler: {(error: Error?) -> Void in
            if error != nil {
                print(error ?? "")
            }
        })
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(status == 1) {
            let elapsed = NSDate.timeIntervalSinceReferenceDate - started
            if let t = self.childNode(withName: "time") as! SKLabelNode?{
                t.text = String(format: "%06.2f", arguments: [elapsed])
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.prepareSound(name: "se_maoudamashii_se_sound09")
    }
}
