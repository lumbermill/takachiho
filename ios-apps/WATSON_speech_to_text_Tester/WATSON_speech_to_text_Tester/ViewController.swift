//
//  ViewController.swift
//  WATSON_speech_to_text_Tester
//
//  Created by koki on 2016/06/08.
//  Copyright © 2016年 koki. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let fileManager = NSFileManager()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var now_recording = false
    let fileName = "sample.wav"

    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 録音ボタンを押した時の挙動
    @IBAction func pushRecordButton(sender: AnyObject) {
        if (now_recording){
            audioRecorder?.stop()
            now_recording = false
            recordButton.title = "録音"
            self.setUpPlayer()
            playButton.enabled = true
        } else {
            setupAudioRecorder()
            audioRecorder?.record()
            now_recording = true
            recordButton.title = "停止"
            playButton.enabled = false
        }
    }
    
    // 再生ボタンを押した時の挙動
    @IBAction func pushPlayButton(sender: AnyObject) {
        if (audioPlayer!.playing) {
            audioPlayer!.stop()
        } else {
            audioPlayer!.play()
        }
    }
    
    func setUpPlayer() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategorySoloAmbient)
        try! session.setActive(true)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: self.documentFilePath())
            audioPlayer?.channelAssignments
            audioPlayer!.prepareToPlay()
        } catch {
            print("AVAudioPlayerの作成に失敗")
        }
    }
    
    // 録音するために必要な設定を行う
    // viewDidLoad時に行う
    func setupAudioRecorder() {
        // 再生と録音機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        let recordSetting : [String : AnyObject] = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey : 16,
            AVLinearPCMIsFloatKey:false,
            AVLinearPCMIsBigEndianKey:false,
            AVEncoderAudioQualityKey : AVAudioQuality.Min.rawValue
        ]
        do {
            try audioRecorder = AVAudioRecorder(URL: self.documentFilePath(), settings: recordSetting)
            audioRecorder?.prepareToRecord()
        } catch {
            print("初期設定でerror")
        }
    }

    // 録音するファイルのパスを取得(録音時、再生時に参照)
    func documentFilePath()-> NSURL {
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.URLByAppendingPathComponent(fileName)
    }


}

