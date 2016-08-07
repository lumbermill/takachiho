//
//  Drill.swift
//  Englishoose
//
//  Created by Yosei Ito on 7/3/16.
//  Copyright © 2016 LumberMill, Inc. All rights reserved.
//

import Foundation

class Drill {
    var title:String = ""
    var published_at:String = ""
    var author: String = ""
    var images: [String:String] = [:]
    var options:[[String]] = []

    // 0番目の要素が常に正解
    func answer(index: Int) -> String{
        return options[index][0]
    }
    
    func isValid() -> Bool{
        if(options.count != 12) { return false }
        var b = true
        for o in options {
            if (o.count != 4) { b = false }
        }
        return b
    }
}
