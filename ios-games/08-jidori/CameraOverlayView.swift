//
//  CameraOverlayView.swift
//  08-jidori
//
//  Created by Yosei Ito on 2017/03/30.
//  Copyright © 2017 LumberMill. All rights reserved.
//

import Foundation
import UIKit

class OverlayView: UIView {
    var features: [CIFeature]?
    var at: CGAffineTransform!
    var headgear: UIImage!
    var beak: UIImage!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        at = CGAffineTransform(scaleX: 1, y: -1);
        at = at.translatedBy(x: 0, y: -self.bounds.size.height);
        headgear = UIImage(named: "chicken1")
        beak = UIImage(named: "beak1")
    }
    
    override func draw(_ rect: CGRect) {
        guard let fs = features else {
            return
        }
        for f in fs {
            let r = f.bounds.applying(at)
            let ra = CGRect(x: r.origin.x - r.size.width / 2, y: r.origin.y - r.size.height,
                            width: r.size.width * 2, height: r.size.height * 2)
            headgear.draw(in: ra)
            guard let ff = f as? CIFaceFeature else{
                continue;
            }
            if ff.hasMouthPosition {
                let p = ff.mouthPosition.applying(at);
                let w = ra.size.width/5;
                let r = CGRect(x: p.x - w / 2.0, y: p.y - w / 2.0, width: w ,height: w)
                beak.draw(in: r)
            }
        }
    }
}
