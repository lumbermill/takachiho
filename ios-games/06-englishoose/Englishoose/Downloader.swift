//
//  Downloader.swift
//  Englishoose
//
//  Created by Yosei Ito on 6/29/16.
//  Copyright © 2016 LumberMill, Inc. All rights reserved.
//

import Foundation

class Downloader {
    // Englishoose or Japaneese
    static let TARGET = Bundle.main.infoDictionary?["CFBundleName"] as! String

    static let fm = FileManager.default
    static let BASEURL = "https://lmlab.net/englishoose/"
    static let BASEDIR = NSHomeDirectory()+"/Documents/"
    static let INDEX = "index.json"
    static let SERIAL = "serial.json"
    static var latest_serial = 0
    
    class func fetch_file(file:String, completion: @escaping (_ path:String)->Void) {
        // ファイルが既に存在する場合、ダウンロードしない
        if fm.fileExists(atPath: BASEDIR+file) {
            completion(BASEDIR+file)
            return
        }

        // TODO:ネットに繋がっていない場合、どうエラーを返す？
        let urlstr = BASEURL+file.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            + "?rand=" + String(arc4random())

        guard let url = URL(string: urlstr) else {
            print("Invalid url: "+urlstr)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {
            (data, resp, err) in
            guard let d = data else {
                print("can not get data for \(file)")
                return
            }
            fm.createFile(atPath: BASEDIR+file, contents: d, attributes: nil)
            print("Saved to "+BASEDIR+file)
            completion(BASEDIR+file)
        })
        task.resume()
    }
    
    class func fetch_files(files:[String], completion: @escaping (_ paths:[String]) ->Void) {
        var flags:[String:Bool] = [:]
        for file in files {
            flags[file] = false
            Downloader.fetch_file(file: file, completion: {(path) in
                flags[file] = true
            })
        }
        DispatchQueue.global().async {
            let paths = [String](flags.keys)
            while true {
                var n_green = 0
                for p in paths {
                    print(p)
                    if let b = flags[p] {
                        if (b) { n_green += 1 }
                    }
                }
                if (n_green == paths.count) { break }
                print("\(n_green) / \(paths.count)")
            }
            DispatchQueue.main.async {
                completion(paths)
            }
        }
    }
    
    class func check_update(completion: @escaping (Bool) -> Void) {
        let ud = UserDefaults.standard
        let current_serial = ud.integer(forKey: "serial")
        fetch_file(file: SERIAL, completion: { (path) in
            guard let data = NSData(contentsOfFile: path) else {
                print("Could not get data from "+path)
                return
            }
            do {
                guard let s = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary else {
                    print("Could not parse data from "+path)
                    return
                }
                guard let remote_serial = s["serial"] as? Int else {
                    print("Could not obrain serial from "+path)
                    return
                }
                print("current: \(current_serial), remote: \(remote_serial)")
                latest_serial = remote_serial
                DispatchQueue.main.async {
                    completion(current_serial < remote_serial)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    // 全ファイルダウンロード
    class func fetch_all(completion: @escaping ([Drill]) -> Void) {
        // index.jsonを取得、パースしてさらに関連する画像も全部取得する。
        fetch_file(file: INDEX, completion: { (path) in
            guard let data = NSData(contentsOfFile: path) else {
                print("Could not get data from "+path)
                return
            }
            do {
                var drills:[Drill] = []
                var files:[String] = []
                guard let root = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary else {
                    print("Could not parse data from "+path)
                    clear_all() //  Erase all!
                    completion([])
                    return
                }
                guard let index = root["en"] as? NSArray else {
                    print("Not found the entry "+path)
                    return
                }
                guard let index4ja = root["ja"] as? NSArray else {
                    print("Not found ja entries "+path)
                    return
                }
                for _q in index {
                    guard let q = _q as? NSDictionary else {
                        print("Could not get question.")
                        continue
                    }
                    let d = Drill()
                    d.title = q["title"] == nil ? "" : (q["title"] as! String)
                    d.author = q["created_by"] == nil ? "" : (q["created_by"] as! String)
                    d.published_at = q["created_at"] == nil ? "" : (q["created_at"] as! String)
                    guard let options = q["options"] as? NSArray else {
                        print("Could not get option.")
                        continue
                    }
                    for _o in options{
                        guard let o = _o as? NSArray else {
                            print("Could not get o.")
                            continue
                        }
                        guard let i = o[0] as? String else{
                            print("Could not get i.")
                            continue
                        }
                        files += [i+".png"]
                        if (o.count != 4) { continue }
                        d.options += [o as! [String]]
                        d.images[i] = i+".png"
                    }
                    if("Japaneese" == TARGET){
                        // Localization
                        let i = drills.count
                        if let qj = index4ja[i] as? NSDictionary{
                            d.title = qj["title"] as! String
                            guard let options = qj["options"] as? NSArray else {
                                print("Could not get option.")
                                continue
                            }
                            var names:[String] = []
                            for _o in d.options{
                                names += [_o[0]]
                            }
                            d.options = []
                            for _o in options{
                                guard let o = _o as? NSArray else {
                                    print("Could not get o.")
                                    continue
                                }
                                if (o.count != 4) { continue }
                                d.options += [o as! [String]]
                                d.images[o[0] as! String] = names[0]+".png"
                                names.removeFirst()
                            }

                        }
                    }
                    drills += [d]
                }
                fetch_files(files: files, completion: { (paths) in
                    DispatchQueue.main.async {
                        completion(drills)
                    }
                    let ud = UserDefaults.standard
                    if(ud.integer(forKey: "serial") == 0){
                        ud.set(latest_serial, forKey: "serial")
                        ud.synchronize()
                    }
                })
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    class func clear_all() {
        do {
            let contents = try fm.contentsOfDirectory(atPath: BASEDIR)
            for c in contents{
                try fm.removeItem(atPath: BASEDIR+c)
            }
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        let ud = UserDefaults.standard
        ud.set(0, forKey: "serial")
        ud.synchronize()

    }
}
