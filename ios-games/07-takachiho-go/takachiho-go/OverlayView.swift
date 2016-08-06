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
    var controller: MapViewController
    var take_or_use: UIButton!
    var cancel_or_retake: UIButton!
    var taking: Bool = true //  or previewing
    var takenImage: UIImage?
    var f :CGRect = CGRectMake(0, 0, 0, 0)
    
    required init(name: String?, imagePicker: UIImagePickerController, controller: MapViewController){
        self.imagePicker = imagePicker
        self.controller = controller
        if (imagePicker.view.frame.width > imagePicker.view.frame.height) {
            f = CGRectMake(0, 0, imagePicker.view.frame.height, imagePicker.view.frame.width)
        }else{
            f = imagePicker.view.frame
        }
        super.init(frame: f)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.imagePicker.delegate = self
        
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
    
    func drawOverlap(context:CGContext?,frame: CGRect){
        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColor(context,[0.8, 0.8, 0.8, 1.0])
        let offset_y = (frame.height - frame.width) / 2
        let center = CGRectMake(0, offset_y, frame.width, frame.width)
        CGContextStrokeRect(context, center)
        CGContextSetFontSize(context, 64)
        CGContextSetFillColor(context, [0.8, 0.8, 0.8, 1.0])
        //CGContextSetFont(context, font: CGFont())
        if let n = name {
            // Name(English)
            let padding = frame.width * 0.02
            let fsize = frame.width * 0.1
            let font = UIFont(name: "Copperplate", size: fsize)!
            let attrs = [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.whiteColor()]
            let an = NSAttributedString(string: n, attributes: attrs)
            an.drawAtPoint(CGPointMake(padding,offset_y + padding))
            if let kanji = Points.sharedInstance.dictionary[n]?.kanji {
                // Name(Kanji)
                let kn = NSAttributedString(string: kanji, attributes: attrs)
                let w = kn.size().width
                let h = kn.size().height
                kn.drawAtPoint(CGPointMake(frame.width - padding - w,offset_y + frame.width - padding - h))
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        drawOverlap(context,frame: f)
        
        if(!taking && takenImage != nil){
            let offset_y = (f.height - f.width) / 2
            let center = CGRectMake(0, offset_y, f.width, f.width)
            takenImage!.drawInRect(center)
            // CGContextDrawImage(context, center, takenImage?.CGImage)
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
            takenImage = nil
            imagePicker.takePicture()
        }else{
            controller.imagePickerController(imagePicker, didFinishPickingImage: takenImage!, editingInfo: nil)
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
        
        // Trim to square.
        // The operation can also remove exif rotation.
        let w = min(image.size.width,image.size.height)
        let rect = CGRectMake(0, 0, w, w)
        var trim = CGRectMake(0, 0, 0, 0)
        let offset = -(max(image.size.width,image.size.height) - w) / 2
        if (image.size.height > image.size.width){
            // portrait
            trim = CGRectMake(0, offset, image.size.width, image.size.height)
        } else{
            // landscape
            trim = CGRectMake(offset, 0, image.size.width, image.size.height)
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0);
        image.drawInRect(trim)
        let context = UIGraphicsGetCurrentContext();
        self.drawOverlap(context,frame:rect)
        takenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setNeedsDisplay()
    }
    
}