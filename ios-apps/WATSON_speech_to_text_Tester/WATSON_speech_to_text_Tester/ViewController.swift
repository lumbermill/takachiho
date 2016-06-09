//
//  ViewController.swift
//  WATSON_speech_to_text_Tester
//
//  Created by koki on 2016/06/08.
//  Copyright © 2016年 koki. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    let fileManager = NSFileManager()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var now_recording = false
    let fileName = "sample.wav"
    let watson = WATSON_S2TAPI()

    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 再生ボタンを押した時の挙動
    @IBAction func pushPlayButton(sender: AnyObject) {
        if (audioPlayer!.playing) {
            audioPlayer!.stop()
            msgLabel.text = ""
        } else {
            audioPlayer!.play()
            msgLabel.text = "音声を再生中です"
        }
    }
    
    // 録音ボタンを押した時の挙動
    @IBAction func pushRecordButton(sender: AnyObject) {
        if (now_recording){
            audioRecorder?.stop()
            now_recording = false
            recordButton.title = "録音"
            self.setUpPlayer()
            playButton.enabled = true
            msgLabel.text = ""
        } else {
            setupAudioRecorder()
            audioRecorder?.record()
            now_recording = true
            recordButton.title = "停止"
            playButton.enabled = false
            msgLabel.text = "録音中です"
        }
    }
    
    // 送信ボタンを押した時の挙動
    @IBAction func pushSendButton(sender: AnyObject) {
        msgLabel.text = "APIに送信中です"
        watson.send(self.documentFilePath(), callback: {_,_,_ in
            dispatch_async(dispatch_get_main_queue(),{
                print(self.watson.result)
                self.msgLabel.text = ""
            })
        })
    }
    
    func setUpPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: self.documentFilePath())
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        } catch {
            print("AVAudioPlayerの作成に失敗")
        }
    }
    
    // 録音するために必要な設定を行う
    func setupAudioRecorder() {
        // 再生と録音機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
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

    // 音声の再生が終了すると呼ばれる
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
                                       successfully flag: Bool) {
        msgLabel.text = ""
    }
}

