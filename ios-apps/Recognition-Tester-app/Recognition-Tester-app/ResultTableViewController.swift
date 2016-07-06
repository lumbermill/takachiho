//
//  ResultTableViewController.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/05.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewController: UITableViewController{
    var query_image = UIImage()
    var api_result_dict: NSDictionary = [:]
    
    override func viewDidLoad() {
        print(query_image)
        print(api_result_dict)
    }
}
