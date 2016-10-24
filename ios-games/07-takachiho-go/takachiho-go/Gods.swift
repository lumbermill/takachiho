//
//  Gods.swift
//  TakachihoGO
//
//  Created by 甲斐翔也 on 10/14/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit

class God {
    var id :String
    var kanji :String
    var kana :String
    var desc :String
    var found: Bool
    
    init(_ id: String, kanji: String, kana: String, desc: String) {
        self.id = id
        self.kanji = kanji
        self.kana = kana
        self.desc = desc
        self.found = false
    }
    
    func photo() -> UIImage? {
        if(!found) { return nil }
        return UIImage(named: id)
    }
}

class Gods {
    
    class var sharedInstance : Gods {
        struct Static {
            static let instance : Gods = Gods()
        }
        return Static.instance
    }
    
    var dictionary:[String: God] = [:]
    var array:[God] = []
    
    init(){
        array += [God("1", kanji: "伊邪那美命", kana: "イザナミノミコト",desc: "伊邪那岐命と共に最初の神様")]
        array += [God("2", kanji: "伊邪那岐命", kana: "イザナギノミコト",desc: "伊邪那美命と共に最初の神様")]
        array += [God("3", kanji: "天照大御神", kana: "アマテラスオオミカミ",desc: "太陽の女神")]
        array += [God("4", kanji: "国狭土尊", kana: "クニサヅチノミコト",desc: "神聖な土地の神様")]
        array += [God("5", kanji: "国常立尊", kana: "クニトコタチノミコト",desc: "天地開闢の際に出現した神様")]
        array += [God("6", kanji: "天鈿女命", kana: "アメノウズメノミコト",desc: "歌、舞、芸能の神様")]
        array += [God("7", kanji: "猿田彦命", kana: "サルタヒコノミコト",desc: "交通安全、教育の神様")]
        array += [God("8", kanji: "八大龍王神", kana: "ハチダイリュウオウ",desc: "水神様")]
        array += [God("9", kanji: "玉依毘売命", kana: "タマヨリヒメ",desc: "神武天皇の母神で育児の神様")]
        array += [God("10", kanji: "豊玉毘売命", kana: "トヨタマヒメ",desc: "神武天皇の祖母で風難除けの神様")]
        array += [God("11", kanji: "八幡神", kana: "ハチマンシン",desc: "鍛冶や農業の神様")]
        array += [God("12", kanji: "牛神大明神", kana: "ウシガミダイミョウジン",desc: "畜産（牛馬）の神様")]
        array += [God("13", kanji: "速玉男命", kana: "ハヤタマオノミコト",desc: "悪縁切りの神様")]
        array += [God("14", kanji: "事解男命", kana: "コトワケオノミコト",desc: "悪縁切りの神様")]
        array += [God("15", kanji: "少彦名命", kana: "スクナヒコナノミコト",desc: "医薬、温泉の神様")]
        array += [God("16", kanji: "保食命", kana: "ウケモチノミコト",desc: "食の神様")]
        array += [God("17", kanji: "日子穂々出見尊", kana: "ヒコホホデノミコト",desc: "神武天皇の祖父")]
        array += [God("18", kanji: "天児屋根命", kana: "アメノコヤネノミコト",desc: "議事、歌の神様")]
        array += [God("19", kanji: "天三降命", kana: "アメノミクダリノミコト",desc: "創造の神様")]
        array += [God("20", kanji: "天村雲命", kana: "アメノムラクモノミコト", desc: "水の神様")]
        array += [God("21", kanji: "武甕槌命", kana: "タケミカヅチノミコト", desc: "武道の神様")]
        array += [God("22", kanji: "天太玉命", kana: "アメノフトタマノミコト", desc: "歌の神様")]
        array += [God("23", kanji: "素戔嗚尊", kana: "スサノオノミコト", desc: "")]
        array += [God("24", kanji: "市杵島姫", kana: "イチキシマヒメ", desc: "航海祈願の神様")]
        array += [God("25", kanji: "端津姫", kana: "タギツヒメ", desc: "航海祈願の神様")]
        array += [God("26", kanji: "田心姫", kana: "タゴリヒメ", desc: "航海祈願の神様")]
        array += [God("27", kanji: "建磐龍命", kana: "タテイワタツノミコト", desc: "開拓の神様")]
        array += [God("28", kanji: "木花咲耶姫", kana: "コノハナサクヤヒメ", desc: "瓊瓊杵命の妻")]
        array += [God("29", kanji: "瓊瓊杵命", kana: "ニニギノミコト", desc: "木花咲耶姫の夫")]
        array += [God("30", kanji: "大年神", kana: "オオトシガミ", desc: "穀物、田植えの神様")]
        array += [God("31", kanji: "大山祇命", kana: "オオヤマヅミノミコト", desc: "山、狩猟の神様")]
        array += [God("32", kanji: "御年神", kana: "オトシガミ", desc: "穀物、田植えの神様")]
        array += [God("33", kanji: "若年神", kana: "ワカトシノカミ", desc: "穀物、田植えの神様")]
        
        for p in array {
            dictionary[p.id] = p
        }
        
    }
    
    // 見つけた神様を神社リストから更新
    func load() -> Void {
        let points = Points.sharedInstance
        for p in points.array {
            if(!p.visited) { continue }
            for g in p.gods {
                if (dictionary[g] != nil){
                    dictionary[g]!.found = true
                }
            }
        }
    }
    
    func n_found() -> Int {
        var n = 0
        for p in array {
            if (p.found) { n += 1 }
        }
        return n
    }
}
