//
//  DetailViewController.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/22/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!


    var detailItem: Point? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if titleLabel == nil { return }
            titleLabel.text = detail.name
            if let i = detail.photo() {
                imageView.image = i
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                descLabel.text = ""
            }else{
                imageView.image = UIImage(named: "Question")
                imageView.contentMode = UIViewContentMode.Center
                descLabel.text = "You haven't found the spot yet."
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


    @IBAction func backButtonPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

