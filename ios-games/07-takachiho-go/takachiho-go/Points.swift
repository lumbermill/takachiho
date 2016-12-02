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
    var gods :[String] = []
    var difficulty :Int = 1 // 1 to 3
    var visited_at :Date?  {
        didSet {
            if let d = visited_at {
                let ud = UserDefaults.standard
                ud.set(d.timeIntervalSinceReferenceDate, forKey: name)
                ud.synchronize()
            }
        }
    }
    var visited :Bool = false
    var webcam: String?

    init(_ name: String, kanji: String, lat: Double, lng: Double, difficulty: Int, gods: [String]) {
        self.name = name
        self.kanji = kanji
        self.lat = lat
        self.lng = lng
        self.difficulty = difficulty
        self.visited = has_photo()
        self.gods = gods
        let ud = UserDefaults.standard
        let t = ud.double(forKey: name)
        if (t > 0){
            visited_at = Date(timeIntervalSinceReferenceDate: t)
        }
    }

    init(_ name: String, kanji: String, lat: Double, lng: Double, webcam: String) {
        self.name = name
        self.kanji = kanji
        self.lat = lat
        self.lng = lng
        self.difficulty = -1
        self.visited = has_photo()
        self.gods = []
        let ud = UserDefaults.standard
        let t = ud.double(forKey: name)
        if (t > 0){
            visited_at = Date(timeIntervalSinceReferenceDate: t)
        }
        self.webcam = webcam
    }

    func path_for_photo(thumb: Bool) -> String {
        return BASEDIR+name+(thumb ? "-thumb" : "")+".jpg"
    }

    func god() -> String? {
        let r = arc4random() % 100
        if r < 2 && gods.count > 2 {
            let gs = gods[2...gods.count-1]
            return gs[Int(arc4random()) % gs.count]
        } else if r < 20 && gods.count > 1{
            return gods[1]
        } else if gods.count > 0{
            return gods[0]
        } else {
            return nil
        }
    }

    func has_photo() -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: path_for_photo(thumb: false))
    }
    
    func has_webcam() -> Bool {
        return webcam != nil
    }

    func create_thumbnail() -> UIImage? {
        if(!has_photo()) { return nil }
        guard let i = photo(thumb: false) else {
            return nil
        }
        let size = CGSize(width: 128, height: 128)
        UIGraphicsBeginImageContext(size)
        i.draw(in: CGRect(x: 0, y:0, width: size.width, height: size.height))
        guard let ri = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let d = UIImageJPEGRepresentation(ri, 1.0) else {
            return nil
        }
        print("begin writing thumbnail data.")
        try? d.write(to: URL(fileURLWithPath: path_for_photo(thumb: true)), options: [.atomic])
        return ri
    }

    func photo(thumb: Bool) -> UIImage? {
        let fm = FileManager.default
        guard let d = fm.contents(atPath: path_for_photo(thumb: thumb)) else {
            if(thumb && has_photo()){
                // サムネイルが無ければ作る
                return create_thumbnail()
            }
            return nil
        }
        return UIImage(data: d)
    }

    func detailText() -> String {
        var v = "";
        if let d = visited_at {
            let df = DateFormatter()
            df.dateStyle = DateFormatter.Style.medium
            df.timeStyle = DateFormatter.Style.short
            v = " - " + df.string(from: d)
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

        array += [Point("Kushifuru", kanji:"槵觸神社", lat:32.710119, lng:131.315543,difficulty:1, gods: ["18","21","22"])]
        array += [Point("Takachiho", kanji:"高千穂神社", lat:32.706422, lng:131.302074,difficulty:1, gods: ["29","28"])]
        array += [Point("Amanoiwato", kanji:"天岩戸神社", lat:32.734211, lng:131.350292,difficulty:1, gods: ["3"])]
        array += [Point("Futagami", kanji:"二上神社", lat:32.686976, lng:131.267234,difficulty:2, gods: ["1","2"])]
        array += [Point("Aratate", kanji:"荒立神社", lat:32.711973, lng:131.317138,difficulty:1, gods: ["7","6"])]
        array += [Point("Akimoto", kanji:"秋元神社", lat:32.651516, lng:131.283982,difficulty:3, gods: ["4","5"])]
        array += [Point("Sobodake", kanji:"祖母嶽神社", lat:32.811019, lng:131.278183,difficulty:3, gods: ["10"])]
        array += [Point("Nakahata", kanji:"中畑神社", lat:32.723787, lng:131.273881,difficulty:3, gods: ["27"])]
        array += [Point("Ishigami", kanji:"石神神社", lat:32.7064742, lng:131.3445836,difficulty:2, gods: ["5","12"])]
        array += [Point("Shimonohachiman", kanji:"下野八幡大神社", lat:32.745196, lng:131.307631,difficulty:3, gods: ["9"])]
        array += [Point("Hachudairyuou", kanji:"八大龍王水神社", lat:32.73022, lng:131.356878,difficulty:2, gods: ["8"])]
        array += [Point("Aisome", kanji:"逢初天神社", lat:32.707272, lng:131.317846,difficulty:1, gods: ["28","29"])]
        array += [Point("Kikunomiya", kanji:"菊宮神社", lat:32.717751, lng:131.305815,difficulty:1, gods: ["18"])]
        array += [Point("Takemiya", kanji:"嶽宮神社", lat:32.7101173, lng:131.2851693,difficulty:2, gods: ["1","2"])]
        array += [Point("Kumano", kanji:"熊野神社", lat:32.771345, lng:131.281986,difficulty:2, gods: ["15","16"])]
        array += [Point("Ochitachi", kanji:"落立神社", lat:32.746587, lng:131.35241,difficulty:2, gods: ["2","1"])]
        array += [Point("Kumanonarutaki", kanji:"熊野鳴瀧神社", lat:32.777605, lng:131.253812,difficulty:2, gods: ["17"])]
        array += [Point("Shibahara", kanji:"芝原神社", lat:32.7058501, lng:131.2636936,difficulty:2, gods: ["13","14"])]
        array += [Point("Miyatoshi", kanji:"端午宮歳大明神", lat:32.7123342, lng:131.3272841,difficulty:1, gods: ["30"])]
        array += [Point("Futatsudake", kanji:"二ツ嶽神社", lat:32.7478558, lng:131.3760164,difficulty:2, gods: ["11"])]
        array += [Point("Hoko", kanji:"鉾神社", lat:32.781628, lng:131.38494,difficulty:3, gods: ["10"])]
        array += [Point("Mukouyama", kanji:"向山神社", lat:32.6884439, lng:131.3058391,difficulty:3, gods: ["23","24","25","26"])]
        array += [Point("Kamino", kanji:"上野神社", lat:32.7649291, lng:131.2995413,difficulty:2, gods: ["28","13","14"])]
        array += [Point("Yunokino", kanji:"柚木野神社 ", lat:32.74175, lng:131.292822,difficulty:2, gods: ["30","32","33","31"])]
        array += [Point("Kurokuchi", kanji:"黒口神社 ", lat:32.746172, lng:131.281836,difficulty:3, gods: ["19","20"])]

        let uk = "http://118.21.109.43:50000/cgi-bin/camera?resolution=640x480&Quality=Standard"
        array += [Point("Kunimigaoka", kanji:"国見ヶ丘", lat: 32.719649, lng: 131.278288, webcam: uk)]
        let ug = "http://118.21.109.46:50000/SnapshotJpeg?Resolution=640x480&Quality=Standard"
        array += [Point("Takachiho Gorge", kanji:"高千穂峡", lat: 32.702834, lng: 131.300754, webcam: ug)]
        let us = "http://118.21.109.45:50000/cgi-bin/camera?resolution=640x480&Quality=Standard"
        array += [Point("Shikimibaru", kanji:"四季見原", lat: 32.7783622, lng: 131.3368301, webcam: us)]
        // Debug
        // array = [Point("Apple",kanji:"アップル",lat:37.330651,lng:-122.030080,difficulty: 1)]

        for p in array {
            dictionary[p.name] = p
        }

        // debug
        // dictionary["Kushifuru"]!.visited = true;
    }

    func load() -> Void {
        let ud = UserDefaults.standard
        for i in 0..<array.count{
            let t = ud.double(forKey: array[i].name)
            if (t > 0){
                array[i].visited = true
                array[i].visited_at = Date(timeIntervalSinceReferenceDate: t)
            }
        }
        for p in array {
            dictionary[p.name] = p
        }
    }

    func is_visited(_ name: String?) -> Bool {
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

    func is_achieved(_ difficulty: Int) -> Bool {
        for p in array{
            if (p.difficulty == difficulty && !p.visited) { return false }
        }
        return true
    }
}
