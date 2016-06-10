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
    var transcript = ""
    
    static let ud = NSUserDefaults.standardUserDefaults()
    static var IBMUname:String  = ""
    static var IBMPass:String   = ""

    static func LoadKeySettings() {
        IBMUname  = ZeroLenTextIfNil(ud.objectForKey("IBMUname"))
        IBMPass   = ZeroLenTextIfNil(ud.objectForKey("IBMPass"))
    }

    static func upateKeySettings() {
        ud.setObject(IBMUname, forKey: "IBMUname")
        ud.setObject(IBMPass, forKey: "IBMPass")
        ud.synchronize()
    }

    private static func ZeroLenTextIfNil(udobj:AnyObject?) -> String{
        if (udobj == nil) {
            return ""
        } else {
            return udobj as! String
        }
    }

    func send(audiofile_path:NSURL, callback:(data:NSData?, response:NSURLResponse?, error:NSError?)->()) {
        result = ""
        transcript = ""
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
            if (data != nil && error == nil) {
                self.result += String.init(data: data!, encoding: NSUTF8StringEncoding)!
                NSLog("WATSON:%@",String.init(data: data!, encoding: NSUTF8StringEncoding)!)
            } else {
                NSLog("WATSON:%@",error!)
                self.result += "WATSON API Error." + error!.localizedDescription
            }
            callback(data: data,response: response, error: error)
        })
        task.resume()
    }
    
    
    func createRequest()->NSMutableURLRequest {
        let uname    = WATSON_S2TAPI.IBMUname
        let password = WATSON_S2TAPI.IBMPass

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