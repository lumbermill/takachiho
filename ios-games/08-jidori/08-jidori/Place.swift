//
//  Place.swift
//  08-jidori
//
//  Created by Yosei Ito on 2017/04/10.
//  Copyright © 2017 LumberMill. All rights reserved.
//

import Foundation

class Place{
    let name :String
    let lat :Double
    let lng :Double

    init(name: String, lat: Double, lng: Double){
        self.name = name
        self.lat = lat
        self.lng = lng
    }

    static let REMOTE = "https://lmlab.net/maps/jidori.json"
    static let LOCAL = NSHomeDirectory()+"/Documents/jidori.json"

    static func load(completion: @escaping (_ places:[Place])->Void){
        // TODO: jsonをロードする、見つからなければキャッシュの使用を試みる
        guard let remote_url = URL(string: REMOTE) else {
            print("Invalid url: "+REMOTE)
            return
        }
        let local_url = URL(fileURLWithPath: LOCAL)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: remote_url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {
            (data, resp, err) in
            var places :[Place] = []
            guard let d = data else {
                return
            }

            do{
                try d.write(to: local_url, options: Data.WritingOptions.atomic)
            } catch {
                print("can not save to "+LOCAL)
                return
            }
            print("Saved to "+LOCAL)

            do {
                guard let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any] else {
                    print("Could not parse data from "+LOCAL)
                    return
                }
                guard let _places = json["places"] as? [[String: Any]] else {
                    print("Could not parse data from "+LOCAL)
                    return
                }
                for p in _places {
                    guard let name = p["name"] as? String else {
                        continue
                    }
                    guard let cood = p["cood"] as? [Double] else {
                        continue
                    }
                    places.append(Place(name: name, lat: cood[0], lng: cood[1]))
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                completion(places)
            }
        })
        task.resume()
    }
}
