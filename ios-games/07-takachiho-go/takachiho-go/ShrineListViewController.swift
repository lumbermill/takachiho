//
//  MasterViewController.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/22/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit
import GameKit

class ShrineListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GKGameCenterControllerDelegate {
    @IBOutlet var tableView: UITableView!
    
    let points = Points.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let p = points.array[(indexPath as NSIndexPath).row]
                let controller = segue.destination as! ShrineDetailViewController
                controller.detailItem = p
                //controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = p.name
                //controller.title = p.name
            }
        }
    }

    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let p = points.array[(indexPath as NSIndexPath).row] 
        cell.textLabel!.text = p.name
        cell.detailTextLabel!.text = p.detailText()
        if let i = p.photo(thumb: true) {
            cell.imageView!.image = i
        } else {
            cell.imageView!.image = UIImage(named: "Question")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    @IBAction func mapButtonPushed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func scoreButtonPushed(_ sender: AnyObject) {
        showScore()
    }


    func showScore(){
        let vc = self
        //let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc.present(gc, animated: true, completion: nil)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

