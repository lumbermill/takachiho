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
    static let TARGET = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as! String

    static let fm = NSFileManager.defaultManager()
    static let BASEURL = "https://lmlab.net/englishoose/"
    static let BASEDIR = NSHomeDirectory()+"/Documents/"
    static let INDEX = "index.json"
    static let SERIAL = "serial.json"
    static var latest_serial = 0
    
    class func fetch_file(file:String, completion: (path:String)->Void) {
        // ファイルが既に存在する場合、ダウンロードしない
        if fm.fileExistsAtPath(BASEDIR+file) {
            completion(path: BASEDIR+file)
            return
        }
        
        // TODO:ネットに繋がっていない場合、どうエラーを返す？
        
        let urlstr = BASEURL+file.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            + "?rand=" + String(rand())
        guard let URL = NSURL(string: urlstr) else {
            print("Invalid url: "+urlstr)
            return
        }
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler:  {
            (data, resp, err) in
            data?.writeToFile(BASEDIR+file, atomically: true)
            print("Saved to "+BASEDIR+file)
            completion(path: BASEDIR+file)
        })
        task.resume()
    }
    
    class func fetch_files(files:[String], completion: (paths:[String]) ->Void) {
        var flags:[String:Bool] = [:]
        for file in files {
            flags[file] = false
            Downloader.fetch_file(file, completion: {(path) in
                flags[file] = true
            })
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let paths = [String](flags.keys)
            while true {
                var green = true
                for p in paths {
                    if (flags[p] == false) { green = false }
                }
                if (green) { break }
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion(paths: paths)
            })
        })
    }
    
    class func check_update(completion: (Bool) -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        let current_serial = ud.integerForKey("serial")
        fetch_file(SERIAL, completion: { (path) in
            guard let data = NSData(contentsOfFile: path) else {
                print("Could not get data from "+path)
                return
            }
            do {
                guard let s = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    print("Could not parse data from "+path)
                    return
                }
                guard let remote_serial = s["serial"] as? Int else {
                    print("Could not obrain serial from "+path)
                    return
                }
                print("current: %d, remote: %d",current_serial,remote_serial)
                latest_serial = remote_serial
                dispatch_async(dispatch_get_main_queue(), {
                    completion(current_serial < remote_serial)
                })
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    // 全ファイルダウンロード
    class func fetch_all(completion: ([Drill]) -> Void) {
        // index.jsonを取得、パースしてさらに関連する画像も全部取得する。
        fetch_file(INDEX, completion: { (path) in
            guard let data = NSData(contentsOfFile: path) else {
                print("Could not get data from "+path)
                return
            }
            do {
                var drills:[Drill] = []
                var files:[String] = []
                guard let root = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
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
                fetch_files(files, completion: { (paths) in
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(drills)
                    })
                    let ud = NSUserDefaults.standardUserDefaults()
                    if(ud.integerForKey("serial") == 0){
                        ud.setInteger(latest_serial, forKey: "serial")
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
        let contents = try fm.contentsOfDirectoryAtPath(BASEDIR)
            for c in contents{
                try fm.removeItemAtPath(BASEDIR+c)
            }
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setInteger(0, forKey: "serial")
        ud.synchronize()

    }
}