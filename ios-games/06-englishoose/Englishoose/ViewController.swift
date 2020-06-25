//
//  ViewController.swift
//  game word
//
//  Created by ItoYosei on 12/11/15.
//  Copyright © 2015 LumberMill, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var drills:[Drill] = []
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drills = [Drill]()
        self.refreshButton.isEnabled = false
        // 問題の更新有無をチェック
        Downloader.check_update(completion: { (has_newer) in
            if (has_newer) {
                self.refreshButton.setTitle("Update", for: .normal)
            }
        })
        // 問題の一覧と画像をダウンロードする（更新をしない限りはローカルのキャッシュ優先
        Downloader.fetch_all(completion: { (drills) in
            self.drills = drills
            self.table.reloadData()
            self.refreshButton.isEnabled = true
        })

        let f = Downloader.TARGET.prefix(1).capitalized
        let o = Downloader.TARGET.suffix(Downloader.TARGET.count - 1)
        titleLabel.text = f + o
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
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
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return drills.count
    }
    
    @IBAction func refreshPushed(sender: AnyObject) {
        Downloader.clear_all()
        self.drills = [Drill]()
        self.refreshButton.isEnabled = false
        Downloader.fetch_all(completion: { (drills) in
            self.drills = drills
            self.table.reloadData()
            self.refreshButton.isEnabled = true
            self.refreshButton.setTitle("Refresh", for: .normal)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "start") {
            if(self.refreshButton.isEnabled == false){
                // 更新中は何もしない
                return
            }
            let quizController:QuizController = segue.destination as! QuizController
            let i = table.indexPathForSelectedRow!.row
            quizController.loadDrill(drill: drills[i])
        }
    }
}

