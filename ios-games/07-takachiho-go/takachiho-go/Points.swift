//
//  Points.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/23/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit

let BASEDIR = NSHomeDirectory()+"/Documents/"

struct Point {
    var name :String
    var kanji :String
    var lat :Double
    var lng :Double
    var difficulty :Int = 1 // 1 to 3
    var visited_at :NSDate?
    var visited :Bool = false
    
    init(_ name: String, kanji: String, lat: Double, lng: Double, difficulty: Int) {
        self.name = name
        self.kanji = kanji
        self.lat = lat
        self.lng = lng
        self.difficulty = difficulty
        self.visited = has_photo()
    }
    
    func path_for_photo() -> String {
        return BASEDIR+name+".jpg"
    }
    
    func has_photo() -> Bool {
        let fm = NSFileManager.defaultManager()
        return fm.fileExistsAtPath(path_for_photo())
        // できれば更新日時を取りたいかも
    }
    
    func photo() -> UIImage? {
        let fm = NSFileManager.defaultManager()
        guard let d = fm.contentsAtPath(path_for_photo()) else {
            return nil
        }
        return UIImage(data: d)
    }
}

class Points {
    
    class var sharedInstance : Points {
        struct Static {
            static let instance : Points = Points()
        }
        return Static.instance
    }
    
    var dictionary:[String: Point] = [:]
    var array:[Point] = []
    
    init(){
        
        array += [Point("Kushifuru",kanji:"槵觸神社",lat: 32.710119,lng: 131.315543,difficulty: 1)]
        array += [Point("Takachiho",kanji:"高千穂神社",lat: 32.706422,lng: 131.302074,difficulty: 1)]
        array += [Point("Amanoiwato",kanji:"天岩戸神社",lat: 32.734211,lng: 131.350292,difficulty: 1)]
        array += [Point("Futagami",kanji:"二上神社",lat: 32.686976,lng: 131.267234,difficulty: 2)]
        array += [Point("Aratate",kanji: "荒立神社",lat: 32.711973,lng: 131.317138,difficulty: 1)]
        array += [Point("Akimoto",kanji: "秋元神社",lat: 32.664870,lng: 131.295042,difficulty: 3)]
        array += [Point("Sobodake",kanji: "祖母嶽神社",lat: 32.811019,lng: 131.278183,difficulty: 3)]
        array += [Point("Nakahata",kanji: "中畑神社",lat: 32.723787,lng: 131.273881,difficulty: 2)]
        array += [Point("Ishigami",kanji: "石神神社",lat: 32.706693,lng: 131.322702,difficulty: 2)]
        array += [Point("Shimonohachiman Daijinja",kanji: "下野八幡大神社",lat: 32.745196,lng: 131.307631,difficulty: 3)]
        array += [Point("Hachudairyuou Suijinja",kanji: "八大龍王水神社",lat: 32.730220,lng: 131.356878,difficulty: 2)]
        array += [Point("Aisome Tenjinja",kanji: "逢初天神社",lat:32.707272 ,lng:131.317846, difficulty: 2)]
        array += [Point("Kikunomiya",kanji: "菊宮神社",lat: 32.717751,lng: 131.305815,difficulty: 2)]
        // array += [Point("Akaishi Shrine",kanji: "赤石神社",lat: ,lng: )] どこ？
        // 嶽宮神社 ？高千穂町押方325
        // 熊野神社 ？高千穂町大字田原640
        // 落立神社 ？岩戸2573
        // 熊野鳴瀧神社 高千穂町河内32-2
        // 芝原神社 ?押方３３７１-3
        // 歳宮神社  高千穂町三田井川登
        // 二ツ嶽神社 岩戸２１５
        // 鉾神社 上岩戸１４５６
        // 向山神社 向山中尾平1806
        // 馬生木 八大之宮 住所すら不明…！
        //        Kuronita 黒仁田神社　向山下椎葉4040
        //        Kamino 上野神社 上野3389
        //        Yunokino 柚木野神社 上野932
        //        Kurokuchi 黒口神社 上野2215
        
        // Debug
        array = [Point("Apple",kanji:"アップル",lat:37.330651,lng:-122.030080,difficulty: 1)]
        
        for p in array {
            dictionary[p.name] = p
        }
        
        // debug
        // dictionary["Kushifuru"]!.visited = true;
    }
    
    func is_visited(name: String?) -> Bool {
        guard let n = name else {
            print("No name on the annotation.")
            return false;
        }
        guard let p = dictionary[n] else {
            print(n+" not found")
            return false
        }
        return p.visited
    }
    
}
