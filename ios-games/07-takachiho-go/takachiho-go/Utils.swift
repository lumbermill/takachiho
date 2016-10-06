//
//  Utils.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/24/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    class func imageFromView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0);
        let context = UIGraphicsGetCurrentContext();
        context?.translateBy(x: -view.frame.origin.x, y: -view.frame.origin.y);
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageFromScreen(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0);
        let context = UIGraphicsGetCurrentContext();
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func getCameraViewTransformY() -> CGFloat {
        var ty:CGFloat = 0.0
        let sh = UIScreen.main.bounds.height // screen height
        let ch = UIScreen.main.bounds.width
        if (sh > ch){
            ty = (sh - ch / 3 * 4) / 2.0;
        } else{
            ty = (ch - sh / 3 * 4) / 2.0;
        }
        return ty
    }
}

// OverlayViewは固定が必要なため、未使用
class ImagePicker: UIImagePickerController {
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
}
