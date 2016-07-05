//
//  RecognitionAPI.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/05.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit

class RecognitionAPI {
    let url = "http://153.120.93.203:8080/Upload"
    var result = ""
    var result_dict = NSDictionary()
    var upload_image_size = CGSize()
    var error = false

    func send(image:UIImage,callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        var imagedata = UIImageJPEGRepresentation(image,1.0)
        // 大きすぎる画像は縮小する
        if (imagedata?.length > 4194304) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(640, oldSize.height / oldSize.width * 640)
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

    func createRequest(url:String)->NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        return request
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
                    self.error = false
                } catch {
                    self.result += "API JSON Parse Error.\n" + String.init(data: data!, encoding: NSUTF8StringEncoding)!
                    self.error = true
                }
                NSLog("API:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("API:%@",error!)
                self.result += "API Error." + error!.localizedDescription
                self.error = true
            }
        })
        task.resume()
    }
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
}
