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
    
    required init(name: String?, imagePicker: UIImagePickerController, controller: MapViewController){
        self.imagePicker = imagePicker
        self.controller = controller
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
            let font = UIFont(name: "Copperplate", size: 40)!
            let attrs = [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.whiteColor()]
            let an = NSAttributedString(string: n, attributes: attrs)
            // CGContextShowTextAtPoint(context, 8, offset_y, n, 9);
            // NSString(string: n).drawAtPoint(CGPointMake(8,offset_y), withAttributes: nil)
            an.drawAtPoint(CGPointMake(8,offset_y))
            if let kanji = Points.sharedInstance.dictionary[n]?.kanji {
                let kn = NSAttributedString(string: kanji, attributes: attrs)
                kn.drawAtPoint(CGPointMake(8,offset_y+100))
                // TODO: 右下に表示
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        drawOverlap(context,frame: frame)
        
        if(takenImage != nil){
            let offset_y = (frame.height - frame.width) / 2
            let center = CGRectMake(0, offset_y, frame.width, frame.width)
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
        print("delegate!")
        
        // TODO: 正方形に切り取り、ビューをオーバラップ
        var trim = CGRectMake(0, 0, 0, 0)
        if (image.size.height > image.size.width){
            // portrait
            let w = image.size.width
            let offset = (image.size.height - w) / 2
            trim = CGRectMake(0, offset, w, w)
        } else{
            // landscape
            let w = image.size.height
            let offset = (image.size.width - w) / 2
            trim = CGRectMake(offset, 0, w, w)
        }
        let rect = CGRectMake(0, 0, trim.size.width, trim.size.height)
        let cgi = image.CGImage;
        let trimmed = CGImageCreateWithImageInRect(cgi, trim);
        
        UIGraphicsBeginImageContextWithOptions(trim.size, true, 0);
        let context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect, trimmed)
        self.drawOverlap(context,frame:rect)
        takenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // TODO: exifの回転を修正する
        // TODO: サイズが合わない？はて？
        if(taking){
            
        }else{
        }
    }
    
}