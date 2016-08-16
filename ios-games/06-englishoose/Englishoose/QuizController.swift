//
//  QuizController.swift
//  game word
//
//  Created by ItoYosei on 12/11/15.
//  Copyright © 2015 LumberMill, Inc. All rights reserved.
//


import UIKit
import AVFoundation

class QuizController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ansImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var data = [Array<String>]() // 問題データ
    var images :[String:String] = [:]
    var ans_data = Array<Bool>()
    var answer = "" // 正解
    
    var view_state = 0 // viewの状態を保持
    
    var ans_count = 0   // 問題数
    var correct_ans = 0 // 正解数
    var start_time: NSTimeInterval = 0
    
    var sound_correct: AVAudioPlayer!
    var sound_wrong: AVAudioPlayer!
    
    @IBAction func buttonPushed(sender: AnyObject) {
        let b = sender as! UIButton
        if let t =  b.titleLabel!.text {
            print(t)
            btn_disable(false)
            b.backgroundColor = UIColor.darkGrayColor()
            self.view.bringSubviewToFront(ansImageView)
            if t == answer{
                view_state = 1
                ans_data.append(true)
                ansImageView.image = UIImage(named: "true")
                if(sound_correct.playing) { sound_correct.stop() }
                sound_correct.play()
            }else{
                view_state = 2
                ans_data.append(false)
                ansImageView.image = UIImage(named: "false")
                if(sound_wrong.playing) { sound_wrong.stop() }
                sound_wrong.play()
            }
        }
    }
    
    func loadDrill(drill: Drill) {
        data = drill.options
        images = drill.images
        shuffle(&data)
    }
    
    // 旧版で使っていたメソッド、もう使いません。
    func loadQuestions(name: String){
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt") {
            data = [Array<String>]()
            do {
                let d = try String(contentsOfFile: path)
                let lines = d.componentsSeparatedByString("\n")
                for line in lines {
                    let row = line.componentsSeparatedByString(",")
                    if row.count != 4 { continue }
                    data.append(row)
                }
            } catch {
                print("can't find data.")
            }
            if data.count < 2 {
                print("too short.")
                return
            }
            
            print(data)
            shuffle(&data)
            print(data)
            print(data.count)
        }else{
            print("can't find path.")
        }
    }
    
    func loadQuestion(i: Int) {
        option1.backgroundColor = UIColor.lightGrayColor()
        option2.backgroundColor = UIColor.lightGrayColor()
        option3.backgroundColor = UIColor.lightGrayColor()
        option4.backgroundColor = UIColor.lightGrayColor()
        ansImageView.image = nil
        let row = data[i]
        answer = row[0]
        imageView.image = UIImage(contentsOfFile: Downloader.BASEDIR+images[answer]!)
        
        var idx = [0,1,2,3]
        shuffle(&idx)
        
        option1.setTitle(row[idx[0]], forState: UIControlState.Normal)
        option2.setTitle(row[idx[1]], forState: UIControlState.Normal)
        option3.setTitle(row[idx[2]], forState: UIControlState.Normal)
        option4.setTitle(row[idx[3]], forState: UIControlState.Normal)
    }
    
    func shuffle<T>(inout array: [T]) {
        for i in 0..<array.count - 1 {
            let j = Int(arc4random_uniform(UInt32(array.count - i))) + i
            guard i != j else { continue }
            swap(&array[i], &array[j])
        }
    }
    
    func createSoundPlayer(name: String) -> AVAudioPlayer?{
        let sound_path = NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!
        let sound_url = NSURL(fileURLWithPath: sound_path)
        do{
            let audioPlayer = try AVAudioPlayer(contentsOfURL: sound_url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            return audioPlayer
        }catch{
            NSLog("Failed to load sound.");
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sound_correct = createSoundPlayer("se_maoudamashii_chime13") // correct
        sound_wrong = createSoundPlayer("se_maoudamashii_onepoint33") // wrong
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        start_time = NSDate.timeIntervalSinceReferenceDate()
        loadQuestion(ans_count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func screenTapped(sender: AnyObject) {
        print(ans_count)
        switch(view_state){
        case 0: // ボタン以外が押された場合
            print("問題:" + String(ans_count))
            print("正解数:" + String(correct_ans))
            break
        case 1: // 正解だった場合
            view_state = 0
            correct_ans += 1
            ans_count += 1
//            self.view.sendSubviewToBack(ansImageView)
            if(ans_count >= data.count){
                performSegueWithIdentifier("end", sender: self)
            }else{
                loadQuestion(ans_count)
            }
            btn_disable(true)
            break
        case 2: // 不正解だった場合
            view_state = 0
            ans_count += 1
//            self.view.sendSubviewToBack(ansImageView)
            if(ans_count >= data.count){
                performSegueWithIdentifier("end", sender: self)
            }else{
                loadQuestion(ans_count)
            }
            btn_disable(true)
            break
        default:
            view_state = 0
            break
        }
    }
    
    func btn_disable(flg: Bool){
        option1.userInteractionEnabled = flg
        option2.userInteractionEnabled = flg
        option3.userInteractionEnabled = flg
        option4.userInteractionEnabled = flg
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "end") {
            let end_time = NSDate.timeIntervalSinceReferenceDate() - start_time
            let checkAnswerController:CheckAnswerController = segue.destinationViewController as! CheckAnswerController
            checkAnswerController.ans = self.correct_ans
            checkAnswerController.data = self.data
            checkAnswerController.images = self.images
            checkAnswerController.time = end_time
            checkAnswerController.ans_data = self.ans_data
        }
    }
    
    @IBAction func backButtonPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
