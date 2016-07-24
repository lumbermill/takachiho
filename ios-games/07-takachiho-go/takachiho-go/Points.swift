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
    var visited_at :NSDate?
    var visited :Bool = false
    
    init(_ name: String, kanji: String, lat: Double, lng: Double) {
        self.name = name
        self.kanji = kanji
        self.lat = lat
        self.lng = lng
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
        
        array += [Point("Kushifuru",kanji:"槵觸神社",lat: 32.710119,lng: 131.315543)]
        array += [Point("Takachiho",kanji:"高千穂神社",lat: 32.706422,lng: 131.302074)]
        array += [Point("AmanoIwato",kanji:"天岩戸神社",lat: 32.734211,lng: 131.350292)]
        array += [Point("Futagami",kanji:"二上神社",lat: 32.686976,lng: 131.267234)]
        
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
