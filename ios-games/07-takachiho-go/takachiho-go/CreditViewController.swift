//
//  CreditViewController.swift
//  TakachihoGO
//
//  Created by Yosei Ito on 10/15/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    let credits = Credits.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = URL(string: "https://lmlab.net/takachihogo/credit.html") {
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

