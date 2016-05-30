//
//  APIKeys.swift
//  basicCamera
//
//  Created by koki on 2016/05/17.
//  Copyright © 2016年 koki. All rights reserved.
//

import Foundation
class APIkeys: NSObject {
    static var GoogleKey:String = ""
    static var MSKey:String     = ""
    static var IBMUname:String  = ""
    static var IBMPass:String   = ""
    static let ud = NSUserDefaults.standardUserDefaults()

    static func LoadKeySettings() {
        GoogleKey = ZeroLenTextIfNil(ud.objectForKey("GoogleKey"))
        MSKey     = ZeroLenTextIfNil(ud.objectForKey("MSKey"))
        IBMUname  = ZeroLenTextIfNil(ud.objectForKey("IBMUname"))
        IBMPass   = ZeroLenTextIfNil(ud.objectForKey("IBMPass"))
    }
    
    static func upateKeySettings() {
        ud.setObject(GoogleKey, forKey: "GoogleKey")
        ud.setObject(MSKey, forKey: "MSKey")
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
}