//
//  DrillModel.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import SwiftUI

class Drill : Identifiable{
    let title:String
    let options:[[String]] // 12 quizes x 4 options
    
    init(dic: NSDictionary) {
        self.title = dic["title"] as! String
        var _options1:[[String]] = []
        for _o1 in (dic["options"] as! NSArray) {
            var _options2:[String] = []
            for _o2 in (_o1 as! NSArray) {
                _options2.append(_o2 as! String)
            }
            _options1.append(_options2)
        }
        self.options = _options1
    }
    
    // The first option is the answer.
    func answer(index: Int) -> String {
        return options[index][0]
    }
    
    func shuffled_options(index: Int) -> [String]{
        return options[index].shuffled()
    }
    
    func image(index: Int) -> Image {
        return Image(options[index][0])
    }
}
