//
//  DetailViewController.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/07.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController: UIViewController{
    var image = UIImage()
    var text = ""

    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(image)
        print(text)
        imgDetail.image = self.image
        lblDetail.text = self.text
    }

}
