//
//  WATSON_S2TAPI.swift
//  WATSON_speech_to_text_Tester
//
//  Created by koki on 2016/06/09.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation

// for IBM Watson Developer Cloud Speech to Text
// http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/speech-to-text.html

class WATSON_S2TAPI: NSObject {
    var result = ""
    var result_dict = NSDictionary()
    
    func send(audiofile_path:NSURL, callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        result = ""
        result_dict = NSDictionary()
        
        let request = createRequest()
        let audio = NSData(contentsOfURL: audiofile_path)
        self.sendRequest(request, audio: audio!,
                         callback: {
                            data,responce,error in
                            callback(data: data,response: responce, error: error)
        })
    }
    
    func sendRequest(request:NSMutableURLRequest, audio:NSData, callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        let start_time = NSDate()
        let session = NSURLSession.sharedSession()
        let task = session.uploadTaskWithRequest(request, fromData: audio, completionHandler: {
            data, response, error -> Void in
            let response_time = abs(Float(start_time.timeIntervalSinceNow))
            self.result = "Response Time:" + String.init(response_time) + "s\n"
            callback(data: data,response: response, error: error)
            if (data != nil && error == nil) {
                do {
                    self.result_dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    self.result += self.result_dict.description
                } catch {
                    self.result += "WATSON API JSON Parse Error.\n" + String.init(data: data!, encoding: NSUTF8StringEncoding)!
                }
                NSLog("WATSON:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("WATSON:%@",error!)
                self.result += "WATSON API Error." + error!.localizedDescription
            }
        })
        task.resume()
    }
    
    func createRequest()->NSMutableURLRequest {
        let uname    = "3b88583b-b848-4206-85cb-8714da955aaa"
        let password = "GYTvmqHwpxHg"

        let userPasswordString = "\(uname):\(password)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let authString = "Basic \(base64EncodedCredential)"

        let request = NSMutableURLRequest(URL: NSURL(string: "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize?timestamps=true&word_alternatives_threshold=0.9&model=ja-JP_BroadbandModel")!)
        request.HTTPMethod = "POST"
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        request.addValue("audio/wav", forHTTPHeaderField: "Content-Type")
        return request
    }

}