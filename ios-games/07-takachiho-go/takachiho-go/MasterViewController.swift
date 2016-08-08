//
//  MasterViewController.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/22/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let points = Points.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let p = points.array[indexPath.row]
                let controller = segue.destinationViewController as! DetailViewController
                controller.detailItem = p
                //controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = p.name
                //controller.title = p.name
            }
        }
    }

    // MARK: - Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.array.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let p = points.array[indexPath.row] 
        cell.textLabel!.text = p.name
        cell.detailTextLabel!.text = p.detailText()
        if let i = p.photo() {
            cell.imageView!.image = i
        } else {
            cell.imageView!.image = UIImage(named: "Question")
        }
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    @IBAction func mapButtonPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

