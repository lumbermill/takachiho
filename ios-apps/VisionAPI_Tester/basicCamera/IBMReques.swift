//
//  IBMReques.swift
//  basicCamera
//
//  Created by koki on 2016/05/18.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation
import UIKit

// for IBM Watson Developer Cloud Visual Recognition
// http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/visual-recognition.html

class IBMRequest: NSObject,APIRequest {
    var result = ""
    var result_dict = NSDictionary()
    
    func send(image:UIImage,callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        result = ""
        result_dict = NSDictionary()
        let oldSize: CGSize = image.size
        let newSize: CGSize = CGSizeMake(320, oldSize.height / oldSize.width * 320) //サイズは320px程度で良いとのこと
        let imagedata = ImageUtil.resizeImage(newSize, image: image)

        let request = createRequest(imagedata)
        
        let start_time = NSDate()
        let session = NSURLSession.sharedSession()
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
                    self.result += "IBM API JSON Parse Error.\n" + String.init(data: data!, encoding: NSUTF8StringEncoding)!
                    if (response != nil) {
                        self.result += "\n" + response!.description
                    }
                }
                NSLog("IBM:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("IBM:%@",error!)
                self.result += "IBM API Error." + error!.localizedDescription
            }
        })
        task.resume()
    }

    func createRequest(image:NSData)->NSMutableURLRequest {
        
        let uname    = APIkeys.IBMUname
        let password = APIkeys.IBMPass
        let userPasswordString = "\(uname):\(password)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let authString = "Basic \(base64EncodedCredential)"

        let request = NSMutableURLRequest(
            URL: NSURL(string: "https://gateway.watsonplatform.net/visual-recognition-beta/api/v2/classify?version=2015-12-02")!)
        request.HTTPMethod = "POST"
        request.addValue(authString, forHTTPHeaderField: "Authorization")

        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        let body: NSMutableData = NSMutableData()
        var postData :String = String()
        let boundary:String = "---------------------------\(uniqueId)"
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type") //(1)
        
        postData += "--\(boundary)\r\n"
        
        postData += "Content-Disposition: form-data; name=\"images_file\"; filename=\"test.jpg\"\r\n" //(2)
        postData += "Content-Type: image/jpeg\r\n\r\n"
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image)
        
        postData = String()
        postData += "\r\n"
        postData += "\r\n--\(boundary)--\r\n"
        
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!) //(3)
        
        request.HTTPBody = NSData(data:body)
        return request
    }

}