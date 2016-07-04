//
//  Downloader.swift
//  Englishoose
//
//  Created by Yosei Ito on 6/29/16.
//  Copyright © 2016 LumberMill, Inc. All rights reserved.
//

import Foundation

class Downloader {
    
    static let fm = NSFileManager.defaultManager()
    static let BASEURL = "https://lmlab.net/englishoose/"
    static let BASEDIR = NSHomeDirectory()+"/Documents/"
    static let INDEX = "index.json"
    
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
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        })
        print("Downloaded from "+BASEURL+file)
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
                guard let index = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray else {
                    print("Could not parse data from "+path)
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
                    }
                    drills += [d]
                }
                fetch_files(files, completion: { (paths) in
                    completion(drills)
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
    }
}