//
//  APIRequest.swift
//  basicCamera
//
//  Created by koki on 2016/05/17.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation
import UIKit

protocol APIRequest {
    func send(image:UIImage,callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->())
    var result:String {get}
}

class ImageUtil {
    static func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImageJPEGRepresentation(newImage,1.0)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    static func makeRectLayer(x:Double,y:Double,width:Double,height:Double, color:UIColor)-> UIView{
        let face_rect = CGRect(x: x, y: y, width: width, height: height)
        let faceOutline = UIView(frame: face_rect)
        faceOutline.layer.borderWidth = 1
        faceOutline.layer.borderColor = color.CGColor
        return faceOutline
    }
}
class Util {
    static func nilZero(nillable:AnyObject?)->AnyObject? {
        if (nillable == nil) {
            return 0.0
        } else {
            return nillable
        }
    }
}
