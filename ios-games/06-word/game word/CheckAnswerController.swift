//
//  CheckViewController.swift
//  game word
//
//  Created by kai on 1/29/16.
//  Copyright © 2016 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit

class CheckAnswerController: UIViewController{
    @IBOutlet weak var ans_count: UILabel!
    @IBOutlet weak var time_label: UILabel!
    
    var ans: Int = 0
    var data = Array<Array<String>>()
    var time: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ans_count.text = String(ans) + "/" + String(data.count)
        time_label.text = String(format: "%.2f", time) + " sec"
    }
}