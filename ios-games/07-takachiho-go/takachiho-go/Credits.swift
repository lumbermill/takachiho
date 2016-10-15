//
//  Credits.swift
//  TakachihoGO
//
//  Created by Yosei Ito on 10/15/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation


class Credits {
    class var sharedInstance : Credits {
        struct Static {
            static let instance : Credits = Credits()
        }
        return Static.instance
    }

    var sponsors:[[String]] = []
    var credits:[[String]] = []
    
    init(){
        credits += [["LumberMill, Inc.","https://lumber-mill.co.jp"]]
    }
}
