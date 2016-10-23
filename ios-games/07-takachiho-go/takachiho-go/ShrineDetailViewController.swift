//
//  DetailViewController.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/22/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit

class ShrineDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!

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
            if let i = detail.photo(thumb: false) {
                imageView.image = i
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                descLabel.text = detail.detailText()
                saveButton.isEnabled = true
            }else{
                imageView.image = UIImage(named: "Question")
                imageView.contentMode = UIViewContentMode.center
                descLabel.text = "You haven't found the spot yet."
                saveButton.isEnabled = false
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
    
    @IBAction func saveButtonPushed(_ sender: AnyObject) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved), nil)
            saveButton.isEnabled = false
        }
    }

    func imageSaved(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if error == nil {
            messageLabel.text = "Saved to Camera roll."
        }else{
            messageLabel.text = "Failed to save. \(error.code)"
        }
    }
}

