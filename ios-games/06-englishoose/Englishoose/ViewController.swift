//
//  ViewController.swift
//  game word
//
//  Created by ItoYosei on 12/11/15.
//  Copyright © 2015 LumberMill, Inc. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ADBannerViewDelegate {
    var drills:[Drill] = []
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drills = [Drill]()
        self.refreshButton.enabled = false
        // 問題の更新有無をチェック
        Downloader.check_update({ (has_newer) in
            if (has_newer) {
                self.refreshButton.setTitle("Update", forState: UIControlState.Normal)
            }
        })
        // 問題の一覧と画像をダウンロードする（更新をしない限りはローカルのキャッシュ優先
        Downloader.fetch_all({ (drills) in
            self.drills = drills
            self.table.reloadData()
            self.refreshButton.enabled = true
        })

        let f = (Downloader.TARGET as NSString).substringToIndex(1).capitalizedString
        let o = (Downloader.TARGET as NSString).substringFromIndex(1)
        titleLabel.text = f + o
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView,
                     cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = table.dequeueReusableCellWithIdentifier("cell")!
        let d = drills[indexPath.row]
        cell.textLabel!.text = d.title
        if(d.isValid()){
            cell.detailTextLabel!.text = d.published_at+", "+d.author
        }else{
            cell.detailTextLabel!.text = String(d.options.count)+", "+d.published_at+", "+d.author
        }
        cell.imageView!.image = UIImage(contentsOfFile: Downloader.BASEDIR+d.images[d.options[0][0]]!)
        return cell
    }
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return drills.count
    }
    
    @IBAction func refreshPushed(sender: AnyObject) {
        Downloader.clear_all()
        self.drills = [Drill]()
        self.refreshButton.enabled = false
        Downloader.fetch_all({ (drills) in
            self.drills = drills
            self.table.reloadData()
            self.refreshButton.enabled = true
            self.refreshButton.setTitle("Refresh", forState: UIControlState.Normal)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "start") {
            if(self.refreshButton.enabled == false){
                // 更新中は何もしない
                return
            }
            let quizController:QuizController = segue.destinationViewController as! QuizController
            let i = table.indexPathForSelectedRow!.row
            quizController.loadDrill(drills[i])
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    }
}

