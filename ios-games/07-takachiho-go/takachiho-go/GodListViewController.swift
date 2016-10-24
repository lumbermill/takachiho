//
//  GodListViewController.swift
//  TakachihoGO
//
//  Created by 甲斐翔也 on 10/14/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//


import UIKit
import GameKit

class GodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GKGameCenterControllerDelegate {
    @IBOutlet var tableView: UITableView!
    
    let gods = Gods.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gods.load()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let p = gods.array[(indexPath as NSIndexPath).row]
                let controller = segue.destination as! GodDetailViewController
                controller.detailItem = p
                // controller.navigationItem.title = p.
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gods.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let p = gods.array[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = p.kanji
        cell.detailTextLabel!.text = p.kana
        if let i = p.photo() {
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

