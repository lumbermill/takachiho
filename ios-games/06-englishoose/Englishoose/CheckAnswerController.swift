//
//  CheckViewController.swift
//  game word
//
//  Created by kai on 1/29/16.
//  Copyright © 2016 LumberMill, Inc. All rights reserved.
//

import Foundation
import UIKit

class CheckAnswerController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var ans_count: UILabel!
    @IBOutlet weak var time_label: UILabel!
    
    var ans: Int = 0
    var data = Array<Array<String>>()
    var ans_data = Array<Bool>()
    var time: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ans_count.text = String(ans) + "/" + String(data.count)
        time_label.text = String(format: "%.2f", time) + " sec"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let testCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let imageView = testCell.contentView.viewWithTag(1) as! UIImageView
        let ansImageView = testCell.contentView.viewWithTag(2) as! UIImageView
        if let path = NSBundle.mainBundle().pathForResource(data[indexPath.row][0], ofType: "png") {
            imageView.image = UIImage(contentsOfFile: path)
            if ans_data[indexPath.row]{
                print("true")
                ansImageView.image = UIImage(named: "true.png")
            }else{
                print("false")
                ansImageView.image = UIImage(named: "false.png")
            }
        }else{
            print("image not found")
        }
        return testCell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
}