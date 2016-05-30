//
//  MSRequest.swift
//  basicCamera
//
//  Created by koki on 2016/05/18.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation
import UIKit

// for Microsoft Cognitive Services Computer Vision API
// https://www.microsoft.com/cognitive-services/en-us/computer-vision-api

class MSRequest: NSObject,APIRequest {
    var url = ""
    var result = ""
    var result_dict = NSDictionary()
    var upload_image_size = CGSize()

    func send(image:UIImage,callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        result = ""
        result_dict = NSDictionary()
        var imagedata = UIImageJPEGRepresentation(image,1.0)
        
        // Resize the image if it exceeds the 4MB API limit
        if (imagedata?.length > 4194304) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            upload_image_size = newSize
            imagedata = ImageUtil.resizeImage(newSize, image: image)
        } else {
            upload_image_size = image.size
        }
        
        let request = createRequest(url)
        self.sendRequest(request, imagedata: imagedata!,
                         callback: {
                            data,responce,error in
                            callback(data: data,response: responce, error: error)
        })
    }
    
    func sendRequest(request:NSMutableURLRequest, imagedata:NSData, callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        let start_time = NSDate()
        let session = NSURLSession.sharedSession()
        let task = session.uploadTaskWithRequest(request, fromData: imagedata, completionHandler: {
            data, response, error -> Void in
            let response_time = abs(Float(start_time.timeIntervalSinceNow))
            self.result = "Response Time:" + String.init(response_time) + "s\n"
            callback(data: data,response: response, error: error)
            if (data != nil && error == nil) {
                do {
                    self.result_dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    self.result += self.result_dict.description
                } catch {
                    self.result += "MS API JSON Parse Error.\n" + String.init(data: data!, encoding: NSUTF8StringEncoding)!
                }
                NSLog("MS:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("MS:%@",error!)
                self.result += "MS API Error." + error!.localizedDescription
            }
        })
        task.resume()
    }
    
    func createRequest(url:String)->NSMutableURLRequest {
        let key = APIkeys.MSKey
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        return request
    }
}

class MSVisualFeaturesRequest: MSRequest {
    override init() {
        super.init()
        self.url = "https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=ALL"
    }
    
    func faceRectLayers(camera_view:UIImageView)-> Array<UIView>? {
        let resize_rate = Double(camera_view.frame.width / upload_image_size.width)
        var face_layers:[UIView] = []
        let faces = result_dict["faces"] as? NSArray
        if (faces == nil) {
            return nil
        }
        for face in faces! {
            var x=0.0, y=0.0, width=0.0, height=0.0
            let boundings = face["faceRectangle"]!
            x  = Double(Util.nilZero(boundings!["left"]) as! Int) * resize_rate + Double(camera_view.frame.origin.x)
            y  = Double(Util.nilZero(boundings!["top"]) as! Int) * resize_rate + Double(camera_view.frame.origin.y)
            width = Double(Util.nilZero(boundings!["width"]) as! Int) * resize_rate
            height = Double(Util.nilZero(boundings!["height"]) as! Int) * resize_rate
            let layer = ImageUtil.makeRectLayer(x, y: y, width: width, height: height, color: UIColor.redColor())
            let label:UILabel = UILabel(frame: CGRect(x: 0,y: height,width: width,height: height / 2))
            label.text = "Gender:\(face["gender"] as! String)\nAge:\(face["age"] as! Int)"
            label.textColor = UIColor.redColor()
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 2
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
            layer.addSubview(label)
            face_layers.append(layer)
        }
        return face_layers
    }
}

class MSDescriveRequest: MSRequest {
    override init() {
        super.init()
        self.url = "https://api.projectoxford.ai/vision/v1.0/describe"
    }
}