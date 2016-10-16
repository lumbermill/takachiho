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
    var imageView: UIImageView!
    var taking: Int = 0 // 0:taking, 1:previewing 2:processing
    var first: Bool = true
    var godImage: UIImage?
    var godX:CGFloat = 0
    var godY:CGFloat = 0
    var godScale:CGFloat = 1.0
    var takenImage: UIImage?
    var f :CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    required init(name: String?, imagePicker: UIImagePickerController, controller: MapViewController){
        self.imagePicker = imagePicker
        self.controller = controller
        if (imagePicker.view.frame.width > imagePicker.view.frame.height) {
            f = CGRect(x: 0, y: 0, width: imagePicker.view.frame.height, height: imagePicker.view.frame.width)
        }else{
            f = imagePicker.view.frame
        }
        super.init(frame: f)
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.imagePicker.delegate = self

        take_or_use = UIButton(frame: CGRect(x: f.width-88,y: f.height-38,width: 80,height: 30))
        take_or_use.setTitle("Take", for: UIControlState())
        take_or_use.addTarget(self, action: #selector(OverlayView.takeOrUsePushed(_:)), for: .touchUpInside)
        take_or_use.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        cancel_or_retake = UIButton(frame: CGRect(x: 8,y: f.height - 38,width: 80,height: 30))
        cancel_or_retake.setTitle("Cancel", for: UIControlState())
        cancel_or_retake.addTarget(self, action: #selector(OverlayView.cancelOrRetakePushed(_:)), for: .touchUpInside)
        imageView = UIImageView()

        self.addSubview(take_or_use)
        self.addSubview(cancel_or_retake)
        self.addSubview(imageView)

        self.name = name

        updateGodImage()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawOverlap(_ context:CGContext?,frame: CGRect){
        if(taking == 2){
            let center = UIScreen.main.bounds
            context?.setFillColor([0.0, 0.0, 0.0, 1.0])
            context?.fill(center)
            context?.setFontSize(64)
            context?.setFillColor([0.8, 0.8, 0.8, 1.0])
            let fsize = frame.width * 0.05
            let font = UIFont(name: "Copperplate", size: fsize)!
            let attrs = [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.white]
            let an = NSAttributedString(string: "Generating..", attributes: attrs)
            an.draw(at: CGPoint(x: 60,y: 200))
            return
        }
        context?.setLineWidth(1)
        context?.setStrokeColor([0.8, 0.8, 0.8, 1.0])
        let offset_y = (frame.height - frame.width) / 2
        let center = CGRect(x: 0, y: offset_y, width: frame.width, height: frame.width)
        context?.stroke(center)
        context?.setFontSize(64)
        context?.setFillColor([0.8, 0.8, 0.8, 1.0])
        //CGContextSetFont(context, font: CGFont())
        if let n = name {
            // Name(English)
            let padding = frame.width * 0.02
            let fsize = frame.width * 0.1
            let font = UIFont(name: "Copperplate", size: fsize)!
            let attrs = [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.white]
            let an = NSAttributedString(string: n, attributes: attrs)
            an.draw(at: CGPoint(x: padding,y: offset_y + padding))
            if let kanji = Points.sharedInstance.dictionary[n]?.kanji {
                // Name(Kanji)
                let kn = NSAttributedString(string: kanji, attributes: attrs)
                let w = kn.size().width
                let h = kn.size().height
                kn.draw(at: CGPoint(x: frame.width - padding - w,y: offset_y + frame.width - padding - h))
            }
        }
    }

    func updateGodImage() {
        if (self.name == nil) { return }
        guard let n = Points.sharedInstance.dictionary[self.name!]?.god() else {
            return
        }
        godImage = UIImage(named: n)
        if(godImage == nil) { return }
        print("god = "+n)
        let offset_y = (frame.height - frame.width) / 2
        godX = CGFloat(arc4random() % UInt32(frame.width - godImage!.size.width))
        godY = CGFloat(arc4random() % UInt32(frame.width - godImage!.size.height)) + offset_y
        godScale = CGFloat(arc4random() % 20) / 100 + 1
    }

    func drawGodImage() {
        guard let image = godImage else { return }
        imageView.image = image

        imageView.frame = CGRect(x: godX, y: godY, width: image.size.width, height: image.size.height)

        let angle = CGFloat(arc4random() % 30) / 100.0
        imageView.center = CGPoint(x: imageView.frame.origin.x + imageView.frame.size.width / 2,y: imageView.frame.origin.y + imageView.frame.size.height / 2)
        imageView.transform = CGAffineTransform.identity.rotated(by: -angle)
        let opts:UIViewAnimationOptions = [.repeat,.autoreverse]
        UIView.animate(withDuration: 1.0, delay: 1.0, options: opts,
                                   animations: {
                                    let t1 = self.imageView.transform.rotated(by: angle*2)
                                    let t2 = t1.scaledBy(x: self.godScale, y: self.godScale)
                                    self.imageView.transform = t2
                                    self.imageView.alpha = 0.6
            }, completion: { (b) in
                self.imageView.transform = CGAffineTransform.identity
            })
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        drawOverlap(context,frame: f)

        if(taking == 1 && takenImage != nil){
            let offset_y = (f.height - f.width) / 2
            let center = CGRect(x: 0, y: offset_y, width: f.width, height: f.width)
            takenImage!.draw(in: center)
            // CGContextDrawImage(context, center, takenImage?.CGImage)
        } else if (first){
            drawGodImage()
            first = false
        }
    }
    
    func reset(name: String) -> Void{
        // print("reset")
        self.name = name
        first = true
        takenImage = nil
        godImage = nil
        taking = 1
        take_or_use.isEnabled = true
        cancel_or_retake.isEnabled = true
        mediate()
    }

    func mediate() -> Void {
        if(taking == 0){
            take_or_use.setTitle("Use", for: UIControlState())
            cancel_or_retake.setTitle("Retake", for: UIControlState())
            taking = 1
        }else if(taking == 1){
            take_or_use.setTitle("Take", for: UIControlState())
            cancel_or_retake.setTitle("Cancel", for: UIControlState())
            taking = 0
        }
        // workaround for iOS10
        //imagePicker.cameraViewTransform.ty = Utils.getCameraViewTransformY()

        self.setNeedsDisplay()
    }

    func takeOrUsePushed(_ sender: AnyObject) {
        // print("take or use")
        take_or_use.isEnabled = false
        cancel_or_retake.isEnabled = false
        if(taking == 0){
            // take
            takenImage = nil
            imagePicker.takePicture()
            taking = 2 // processing
            print("taking2-1")
            //imageView.removeFromSuperview()
            imageView.image = nil
        }else if(taking == 1){
            // use
            controller.imagePickerController(imagePicker, didFinishPickingImage: takenImage!, editingInfo: nil)
        }
        mediate()
    }

    func cancelOrRetakePushed(_ sender: AnyObject) {
        // print("cancel or retake")
        if(taking == 0){
            // cancel
            imagePicker.dismiss(animated: true, completion: {})
        }else if(taking == 1){
            // retake
            //self.addSubview(imageView)
            drawGodImage()
        }
        mediate()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("taking2-2")
        taking = 0
        mediate()
        // workaround for iOS10
        imagePicker.cameraViewTransform.ty = Utils.getCameraViewTransformY()

        // Trim to square.
        // The operation can also remove exif rotation.
        let w = min(image.size.width,image.size.height)
        let rect = CGRect(x: 0, y: 0, width: w, height: w)
        var trim = CGRect(x: 0, y: 0, width: 0, height: 0)
        let offset = -(max(image.size.width,image.size.height) - w) / 2
        if (image.size.height > image.size.width){
            // portrait
            trim = CGRect(x: 0, y: offset, width: image.size.width, height: image.size.height)
        } else{
            // landscape
            trim = CGRect(x: offset, y: 0, width: image.size.width, height: image.size.height)
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0);
        image.draw(in: trim)
        let context = UIGraphicsGetCurrentContext();
        self.drawOverlap(context,frame:rect)
        if(godImage != nil) {
            let scale = w / frame.width
            godImage!.draw(in: CGRect(x: godX * scale, y: godY * scale + offset * 2, width: godImage!.size.width * scale, height: godImage!.size.height * scale))
        }
        takenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setNeedsDisplay()
        take_or_use.isEnabled = true
        cancel_or_retake.isEnabled = true
    }

}
