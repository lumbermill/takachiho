//
//  GameViewController.swift
//  09-b-eater
//
//  Created by Yosei Ito on 2019/07/08.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    var timer:Timer?
    var bgmPlayer:AVAudioPlayer?
    var overPlayer:AVAudioPlayer?

    @IBOutlet weak var fatherImageView: UIImageView!
    @IBOutlet weak var boyImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!

    let fathers = ["father1","father2","father3"] // 0,1: watching TV(safe) 2: looking at his son
    let boys = ["boy1","boy2","boy3"] // 0: not eating  1,2: eating B
    var eating:Bool = false
    var score:Int = 0
    var father_pos:Int = 0

    override func viewDidLoad() {
        if bgmPlayer == nil {
            let ad = NSDataAsset(name: "sound-bgm")!
            bgmPlayer = try! AVAudioPlayer(data: ad.data)
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.volume = 0.5
            bgmPlayer?.numberOfLoops = -1 // loop
        }
        if overPlayer == nil {
            let ad = NSDataAsset(name: "sound-over")!
            overPlayer = try! AVAudioPlayer(data: ad.data)
            overPlayer?.prepareToPlay()
            overPlayer?.volume = 0.9
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        startGame()
    }

    @IBAction func buttonTouchUp(_ sender: Any) {
        if !button.isEnabled { return }
        print("touchUp inside")
        eating = false
        self.boyImageView.image = UIImage(named: self.boys[0])
    }

    @IBAction func buttonTouchDown(_ sender: Any) {
        print("touchDown")
        eating = true
        self.boyImageView.image = UIImage(named: self.boys[1])
    }

    @IBAction func retryPushed(_ sender: Any) {
        startGame()
        retryButton.isEnabled = false
        retryButton.isHidden = true
    }

    @IBAction func topPushed(_ sender: Any) {
        if let t = self.timer { t.invalidate() }
        bgmPlayer?.stop()
        self.dismiss(animated: true, completion: nil)
    }

    func startGame() {
        score = 0
        self.scoreLabel.text = "Score: \(self.score)"
        var i = 0
        button.setTitle("Eat B!", for: .normal)
        button.isEnabled = true
        father_pos = 0
        eating = false
        fatherImageView.image = UIImage(named: fathers[0])
        boyImageView.image = UIImage(named: boys[0])
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            if !self.button.isEnabled { return }
            if self.updateFather() {
                self.fatherImageView.image = UIImage(named: self.fathers[self.father_pos])
                if (self.eating) {
                    self.boyImageView.image = UIImage(named: self.boys[i % 2 + 1])
                    self.score += 1
                    self.scoreLabel.text = "Score: \(self.score)"
                }
                i += 1
            } else {
                // Game over
                if let t = self.timer { t.invalidate() }
                self.button.isEnabled = false
                self.fatherImageView.image = self.invertedImage(image: UIImage(named: self.fathers[2]))
                self.boyImageView.image = UIImage(named: self.boys[2])
                self.bgmPlayer?.stop()
                self.overPlayer?.play()
                self.retryButton.isEnabled = true
                self.retryButton.isHidden = false
                // store the score
                let ud = UserDefaults.standard
                let hs = ud.integer(forKey: "highscore")
                if (self.score > hs) {
                    ud.set(self.score, forKey: "highscore")
                    ud.synchronize()
                }
            }
        })
        bgmPlayer?.play()
    }

    func updateFather() -> Bool {
        if self.father_pos == 0 {
            if Int.random(in: 0..<10) < 2 { // 20 %
                self.father_pos = 1
            } else {
                self.father_pos = 0
            }
        } else if self.father_pos == 1 {
            let r = Int.random(in: 0..<10)
            if r < 2 { // 20 %
                self.father_pos = 2
            } else if r < 4 {
                self.father_pos = 1
            } else {
                self.father_pos = 0
            }
        } else if self.father_pos == 2 {
            // Judge!!
            if (eating) { return false }
            if Int.random(in: 0..<10) < 5 { // 50 %
                self.father_pos = 1
            } else {
                self.father_pos = 2
            }
        }
        return true
    }

    func invertedImage(image:UIImage?) -> UIImage? {
        guard let i = image else { return nil }
        guard let ciImage:CIImage = CIImage(image:i) else { return nil }
        let ciFilter:CIFilter = CIFilter(name: "CIColorInvert")!
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        let ciContext:CIContext = CIContext(options: nil)
        guard let outputImage = ciFilter.outputImage else { return nil }
        guard let cgimg:CGImage = ciContext.createCGImage(outputImage, from:outputImage.extent) else { return nil }
        return UIImage(cgImage: cgimg)
    }
}
