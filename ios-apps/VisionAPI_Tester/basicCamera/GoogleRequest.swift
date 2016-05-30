//
//  GoogleRequest.swift
//  basicCamera
//
//  Created by koki on 2016/05/17.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation
import UIKit

// for Gooogle Cloud Vision API
// https://cloud.google.com/vision/docs/?hl=ja
// 参考情報(APIキーの取得方法など)：https://syncer.jp/cloud-vision-api

class GoogleRequest: NSObject,APIRequest {
    var result = ""
    var result_dict = NSDictionary()
    var upload_image_size = CGSize()
    
    func send(image: UIImage,callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        result = ""
        result_dict = NSDictionary()
        let imagedata:String = base64EncodeImage(image) // 画像をJSONに入れるためにbase64エンコードする
        let request = createRequest(imagedata)
        let start_time = NSDate()
        let session = NSURLSession.sharedSession()
        // run the request
        let task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            let response_time = abs(Float(start_time.timeIntervalSinceNow))
            self.result = "Response Time:" + String.init(response_time) + "s\n"
            callback(data: data,response: response, error: error)
            if (data != nil && error == nil) {
                do {
                    self.result_dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    self.result += self.result_dict.description
                } catch {
                    self.result += "Google API JSON Parse Error.¥n" + String.init(data: data!, encoding: NSUTF8StringEncoding)!
                }
                NSLog("Google:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("Google:%@",error!)
                self.result += "Google API Error." + error!.localizedDescription
            }
        })
        task.resume()
    }
    
    func base64EncodeImage(image: UIImage) -> String {
        var imagedata = UIImageJPEGRepresentation(image,1.0)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.length > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            upload_image_size = newSize
            imagedata = ImageUtil.resizeImage(newSize, image: image)
        } else {
            upload_image_size = image.size
        }
        
        return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    func createRequest(imageData: String) -> NSMutableURLRequest {
        // Create our request URL
        let key = APIkeys.GoogleKey
        let request = NSMutableURLRequest(
            URL: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(key)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            NSBundle.mainBundle().bundleIdentifier ?? "",
            forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest: [String: AnyObject] = [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        // Serialize the JSON
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        
        return request
    }
    
    func faceRectLayers(camera_view:UIImageView)-> Array<UIView>? {
        let resize_rate = Double(camera_view.frame.width / upload_image_size.width)
        var face_layers:[UIView] = []
        let faces = result_dict["responses"]![0]["faceAnnotations"] as? NSArray
        if (faces == nil) {
            return nil
        }
        for face in faces! {
            var x=0.0, y=0.0, x2=0.0, y2=0.0
            let boundings = face["boundingPoly"]!!["vertices"]
            x  = Double(Util.nilZero(boundings!![0]["x"]) as! Int) * resize_rate + Double(camera_view.frame.origin.x)
            y  = Double(Util.nilZero(boundings!![0]["y"]) as! Int) * resize_rate + Double(camera_view.frame.origin.y)
            x2 = Double(Util.nilZero(boundings!![2]["x"]) as! Int) * resize_rate
            y2 = Double(Util.nilZero(boundings!![2]["y"]) as! Int) * resize_rate
            let layer = ImageUtil.makeRectLayer(x, y: y, width: x2-x, height: y2-y, color: UIColor.redColor())
            face_layers.append(layer)
        }
        return face_layers
    }
}