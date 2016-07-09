//
//  ConfigViewController.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/08.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit
class ConfigViewController: UIViewController{
    let ud = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var txtApiUrl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtApiUrl.text = ud.stringForKey("api_url")
    }
    
    @IBAction func enterApiUrl(sender: AnyObject) {
        ud.setObject(txtApiUrl.text!, forKey: "api_url")
        ud.synchronize()
    }
}
