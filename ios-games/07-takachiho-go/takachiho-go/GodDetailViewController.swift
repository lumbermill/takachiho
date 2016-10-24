//
//  DetailGodViewController.swift
//  TakachihoGO
//
//  Created by Yosei Ito on 10/23/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit

class GodDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var desc1Label: UILabel!
    @IBOutlet weak var desc2Label: UILabel!
    
    var detailItem: God? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if titleLabel == nil { return }
            titleLabel.text = detail.kanji
            desc1Label.text = detail.desc
            desc2Label.text = "" // Not used for now.
            
            if detail.found {
                imageView.image = detail.photo()
                imageView.contentMode = UIViewContentMode.scaleAspectFit
            }else{
                imageView.image = UIImage(named: "Question")
                imageView.contentMode = UIViewContentMode.center
                desc1Label.text = "You haven't found the god yet."
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backButtonPushed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}

