//
//  WebcamViewController.swift
//  TakachihoGO
//
//  Created by Yosei Ito on 2016/11/12.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit

class WebcamViewController: UIViewController{

    var controller :MapViewController?
    var timer: Timer?
    var point: Point?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.loadImage), userInfo: nil, repeats: true);
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let t = timer {
            t.invalidate()
        }
    }
    

    func loadImage() {
        guard let u1 = point?.webcam else {
            print("url not set.")
            return
        }
        guard let u2 = URL(string: u1) else {
            print("invalid url.")
            return
        }
        do {
            let d = try Data(contentsOf: u2)
            let i = UIImage(data: d)
            imageView.image = i
            print("Image reloaded.")
        }catch{
            print("can't load data from url.")
        }
    }
    
    @IBAction func cancelButtonPushed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takeButtonPushed(_ sender: Any) {
        print("take!")
        guard let image = imageView.image else{
            return
        }
        guard var p = point else {
            return
        }
        
        DispatchQueue.global().async {
            var b = false
            if let d = UIImageJPEGRepresentation(image, 1.0) {
                do{
                    try d.write(to: URL(fileURLWithPath: p.path_for_photo(thumb: false)), options: [.atomic])
                    let _ = p.create_thumbnail()
                    b = true
                }catch {
                }
            }
            p.visited = true
            p.visited_at = Date()
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    if let c = self.controller {
                        c.updateForWebcam(b)
                    }
                })
            }
        }

    }
}
