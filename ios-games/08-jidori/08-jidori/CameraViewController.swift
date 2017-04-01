//
//  SecondViewController.swift
//  08-jidori
//
//  Created by Yosei Ito on 2017/03/30.
//  Copyright © 2017 LumberMill. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: OverlayView!
    var session: AVCaptureSession!
    var detector: CIDetector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: frontとbackを切り替え
        // TODO: シャッターを押すボタン付ける
        // TODO: 被り物を選べるように？
        let d = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        
        let cdi:AVCaptureDeviceInput
        do {
            cdi = try AVCaptureDeviceInput(device: d)
        } catch {
            NSLog("Can not initialize AVCaptureDeviceInput")
            return
        }
        
        let cvdo = AVCaptureVideoDataOutput()
        cvdo.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        cvdo.alwaysDiscardsLateVideoFrames = true
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        session.addInput(cdi)
        session.addOutput(cvdo)
        
        detector = CIDetector(ofType: CIDetectorTypeFace,
                              context: nil,
                              options:[CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if (session != nil) {
            session.stopRunning()
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        connection.videoOrientation = .portrait
        self.imageView.image = UIImageFromCMSamleBuffer(sampleBuffer)
    }
    
    fileprivate func UIImageFromCMSamleBuffer(_ buffer:CMSampleBuffer)-> UIImage {
        let pixelBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let options = [CIDetectorSmile : true, CIDetectorEyeBlink : true]
        let image = UIImage(ciImage: ciImage)
        self.overlayView.features = detector.features(in: ciImage, options: options)
        self.overlayView.setNeedsDisplay()
        
        return image
    }
}

