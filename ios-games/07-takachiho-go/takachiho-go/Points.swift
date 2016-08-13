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
    var visited_at :NSDate?  {
        didSet {
            if let d = visited_at {
                let ud = NSUserDefaults.standardUserDefaults()
                ud.setDouble(d.timeIntervalSinceReferenceDate, forKey: name)
                ud.synchronize()
            }
        }
    }
    var visited :Bool = false
    
    init(_ name: String, kanji: String, lat: Double, lng: Double, difficulty: Int) {
        self.name = name
        self.kanji = kanji
        self.lat = lat
        self.lng = lng
        self.difficulty = difficulty
        self.visited = has_photo()
        let ud = NSUserDefaults.standardUserDefaults()
        let t = ud.doubleForKey(name)
        if (t > 0){
            visited_at = NSDate(timeIntervalSinceReferenceDate: t)
        }
    }

    func path_for_photo() -> String {
        return BASEDIR+name+".jpg"
    }
    
    func has_photo() -> Bool {
        let fm = NSFileManager.defaultManager()
        return fm.fileExistsAtPath(path_for_photo())
    }
    
    func photo() -> UIImage? {
        let fm = NSFileManager.defaultManager()
        guard let d = fm.contentsAtPath(path_for_photo()) else {
            return nil
        }
        return UIImage(data: d)
    }

    func detailText() -> String {
        var v = "";
        if let d = visited_at {
            let df = NSDateFormatter()
            df.dateStyle = NSDateFormatterStyle.MediumStyle
            df.timeStyle = NSDateFormatterStyle.ShortStyle
            v = " - " + df.stringFromDate(d)
        }
        return kanji + v
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
        
        array += [Point("Kushifuru", kanji:"槵觸神社", lat:32.710119, lng:131.315543,difficulty:1)]
        array += [Point("Takachiho", kanji:"高千穂神社", lat:32.706422, lng:131.302074,difficulty:1)]
        array += [Point("Amanoiwato", kanji:"天岩戸神社", lat:32.734211, lng:131.350292,difficulty:1)]
        array += [Point("Futagami", kanji:"二上神社", lat:32.686976, lng:131.267234,difficulty:2)]
        array += [Point("Aratate", kanji:"荒立神社", lat:32.711973, lng:131.317138,difficulty:1)]
        array += [Point("Akimoto", kanji:"秋元神社", lat:32.651516, lng:131.283982,difficulty:3)]
        array += [Point("Sobodake", kanji:"祖母嶽神社", lat:32.811019, lng:131.278183,difficulty:3)]
        array += [Point("Nakahata", kanji:"中畑神社", lat:32.723787, lng:131.273881,difficulty:3)]
        array += [Point("Ishigami", kanji:"石神神社", lat:32.7064742, lng:131.3445836,difficulty:2)]
        array += [Point("Shimonohachiman Daijinja", kanji:"下野八幡大神社", lat:32.745196, lng:131.307631,difficulty:3)]
        array += [Point("Hachudairyuou Suijinja", kanji:"八大龍王水神社", lat:32.73022, lng:131.356878,difficulty:2)]
        array += [Point("Aisome Tenjinja", kanji:"逢初天神社", lat:32.707272, lng:131.317846,difficulty:1)]
        array += [Point("Kikunomiya", kanji:"菊宮神社", lat:32.717751, lng:131.305815,difficulty:1)]
        array += [Point("Takemiya", kanji:"嶽宮神社", lat:32.7101173, lng:131.2851693,difficulty:2)]
        array += [Point("Kumano", kanji:"熊野神社", lat:32.771345, lng:131.281986,difficulty:2)]
        array += [Point("Ochitachi", kanji:"落立神社", lat:32.746587, lng:131.35241,difficulty:2)]
        array += [Point("Kumanonarutaki", kanji:"熊野鳴瀧神社", lat:32.777605, lng:131.253812,difficulty:2)]
        array += [Point("Shibahara", kanji:"芝原神社", lat:32.7058501, lng:131.2636936,difficulty:2)]
        array += [Point("Toshimiya", kanji:"端午宮歳大明神", lat:32.7123342, lng:131.3272841,difficulty:1)]
        array += [Point("Futatsudake", kanji:"二ツ嶽神社", lat:32.7478558, lng:131.3760164,difficulty:2)]
        array += [Point("Hoko", kanji:"鉾神社", lat:32.781628, lng:131.38494,difficulty:3)]
        array += [Point("Mukouyama", kanji:"向山神社", lat:32.6884439, lng:131.3058391,difficulty:3)]
        array += [Point("Kamino", kanji:"上野神社 ", lat:32.7649291, lng:131.2995413,difficulty:1)]
        array += [Point("Yunokino", kanji:"柚木野神社 ", lat:32.74175, lng:131.292822,difficulty:2)]
        array += [Point("Kurokuchi", kanji:"黒口神社 ", lat:32.746172, lng:131.281836,difficulty:3)]
        
        // Debug
        // array = [Point("Apple",kanji:"アップル",lat:37.330651,lng:-122.030080,difficulty: 1)]
        
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
    
    func n_visited() -> Int {
        var n = 0
        for p in array {
            if (p.visited) { n += 1 }
        }
        return n
    }

    func is_achieved(difficulty: Int) -> Bool {
        for p in array{
            if (p.difficulty == difficulty && !p.visited) { return false }
        }
        return true
    }
}
