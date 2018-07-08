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
    var devicePosition = AVCaptureDevice.Position.front
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.transform = imageView.transform.scaledBy(x: -1,y: 1) // 左右反転
        overlayView.transform = overlayView.transform.scaledBy(x: -1,y: 1) // 左右反転
        overlayView.controller = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: シャッターを押すボタン付ける
        // TODO: 被り物を選べるように？
        let d = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: devicePosition)
        
        let cdi:AVCaptureDeviceInput
        do {
            cdi = try AVCaptureDeviceInput(device: d!)
        } catch {
            NSLog("Can not initialize AVCaptureDeviceInput")
            return
        }
        
        let cvdo = AVCaptureVideoDataOutput()
        cvdo.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        cvdo.alwaysDiscardsLateVideoFrames = true
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.medium
        
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        self.imageView.image = UIImageFromCMSamleBuffer(sampleBuffer)
    }
    
    @IBAction func flipTouched(_ sender: Any) {
        if devicePosition == AVCaptureDevice.Position.front {
            devicePosition = AVCaptureDevice.Position.back
        }else{
            devicePosition = AVCaptureDevice.Position.front
        }
        // カメラを切り替える度に左右反転する
        imageView.transform = imageView.transform.scaledBy(x: -1,y: 1)
        overlayView.transform = overlayView.transform.scaledBy(x: -1,y: 1)
        self.viewDidDisappear(false)
        self.viewWillAppear(false)
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

    func takePicture(){
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            let df = DateFormatter()
            df.dateFormat = "yyMMddhhmmss"
            let p = NSHomeDirectory() + "/Documents/"+df.string(from: Date())+".jpg"
            do {
                try data.write(to: URL(fileURLWithPath: p))
            } catch {
                print(error)
            }
        }
        // TODO:シャッター音！
    }
}

