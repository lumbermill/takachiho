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
    var image: UIImage!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        at = CGAffineTransform(scaleX: 1, y: -1);
        at = at.translatedBy(x: 0, y: -self.bounds.size.height);
        image = UIImage(named: "checken1")
    }
    
    override func draw(_ rect: CGRect) {
        guard let fs = features else {
            return
        }
        for f in fs {
            let r = f.bounds.applying(at)
            let ra = CGRect(x: r.origin.x - r.size.width / 2, y: r.origin.y - r.size.height,
                            width: r.size.width * 2, height: r.size.height * 2)
            image.draw(in: ra)
            guard let ff = f as? CIFaceFeature else{
                continue;
            }
            if ff.hasSmile {
                NSString(string: "Smile!!").draw(at: r.origin, withAttributes: nil)
                print("Smile!!")
            }
        }
    }
}
