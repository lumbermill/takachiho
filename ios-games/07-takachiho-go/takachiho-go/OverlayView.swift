//
//  OverlayView.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/24/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit

class OverlayView: UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var name: String?
    var imagePicker: UIImagePickerController
    var take_or_use: UIButton!
    var cancel_or_retake: UIButton!
    var taking: Bool = true //  or previewing
    var takenImage: UIImage?
    
    required init(name: String?, imagePicker: UIImagePickerController){
        self.imagePicker = imagePicker
        super.init(frame: imagePicker.view.frame)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.imagePicker.delegate = self
        
        let f = self.frame
        take_or_use = UIButton(frame: CGRectMake(f.width-88,f.height-38,80,30))
        take_or_use.setTitle("Take", forState: UIControlState.Normal)
        take_or_use.addTarget(self, action: #selector(OverlayView.takeOrUsePushed(_:)), forControlEvents: .TouchUpInside)
        take_or_use.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        cancel_or_retake = UIButton(frame: CGRectMake(8,f.height - 38,80,30))
        cancel_or_retake.setTitle("Cancel", forState: UIControlState.Normal)
        cancel_or_retake.addTarget(self, action: #selector(OverlayView.cancelOrRetakePushed(_:)), forControlEvents: .TouchUpInside)
        
        self.addSubview(take_or_use)
        self.addSubview(cancel_or_retake)
        
        self.name = name
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColor(context,[0.8, 0.8, 0.8, 1.0])
        let offset_y = (frame.height - frame.width) / 2
        let center = CGRectMake(0, offset_y, frame.width, frame.width)
        CGContextStrokeRect(context, center)
        CGContextSetFontSize(context, 64)
        CGContextSetFillColor(context, [0.8, 0.8, 0.8, 1.0])
        //CGContextSetFont(context, font: CGFont())
        if let n = name {
            // CGContextShowTextAtPoint(context, 8, offset_y, n, 9);
            NSString(string: n).drawAtPoint(CGPointMake(8,offset_y), withAttributes: nil)
        }
        
        if(takenImage != nil){
            CGContextDrawImage(context, center, takenImage?.CGImage)
        }
    }
    
    
    func mediate() -> Void {
        if(taking){
            take_or_use.setTitle("Use", forState: UIControlState.Normal)
            cancel_or_retake.setTitle("Retake", forState: UIControlState.Normal)
            taking = false
        }else{
            take_or_use.setTitle("Take", forState: UIControlState.Normal)
            cancel_or_retake.setTitle("Cancel", forState: UIControlState.Normal)
            taking = true
        }
        self.setNeedsDisplay()
    }
    
    func takeOrUsePushed(sender: AnyObject) {
        print("take or use")
        if(taking){
            imagePicker.takePicture()
            //takenImage = Utils.imageFromScreen(imagePicker.view)
        }else{
            imagePicker.dismissViewControllerAnimated(true, completion: {})
        }
        mediate()
    }
    func cancelOrRetakePushed(sender: AnyObject) {
        print("cancel or retake")
        if(taking){
            imagePicker.dismissViewControllerAnimated(true, completion: {})
        }else{
            
        }
        mediate()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("delegate!")
        //
        //UIViewをキャプチャしたものを写真にできる？？
        //それともちゃんと合成して作るか？？
    }
    
}