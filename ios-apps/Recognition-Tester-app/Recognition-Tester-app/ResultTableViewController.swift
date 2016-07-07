//
//  ResultTableViewController.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/05.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//
import Foundation
import UIKit
class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var query_image = UIImage()
    var api_result_dict: NSDictionary = [:]
    var image_cache: NSMutableDictionary = [:]
    var current_image = UIImage()
    var current_text = ""
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["質問画像", "認識結果"]

    // Tableで使用する配列を定義する.
    private let queryImageRows: NSArray = ["質問画像"]
    private var results: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(query_image)
        print(api_result_dict)
        image_cache = [:] // キャッシュをクリア
        results = api_result_dict["results"] as! NSArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func back(segue:UIStoryboardSegue){//戻るボタン用
        print("back")
    }

    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mySections.count
    }

    /*
     セクションのタイトルを返す.
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section] as? String
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            print("Value: \(queryImageRows[indexPath.row])")
            current_text = "\(queryImageRows[indexPath.row])"
            current_image = query_image
        } else if indexPath.section == 1 {
            print("Value: \(results[indexPath.row])")
            let label = results[indexPath.row]["label"] as! String!
            let score = "\(results[indexPath.row]["score"] as! NSNumber!)"
            let jan  = results[indexPath.row]["jan"] as! String!
            let id  = results[indexPath.row]["id"] as! String!
            current_text = "\(label)\nスコア：\(score), JAN：\(jan), ID：\(id)"
            let imagePath = results[indexPath.row]["labelImgSrc"] as! String
            let url = imageURL(imagePath)
            current_image = imageFromURL(url)!
        }
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    /*
     テーブルに表示する配列の総数を返す.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return queryImageRows.count
        } else if section == 1 {
            return results.count
        } else {
            return 0
        }
    }
    
    /*
     行の高さを返す
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    /*
     Cellに値を設定する.
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) 
        cell.imageView?.image = nil
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(queryImageRows[indexPath.row])"
            cell.detailTextLabel!.text = ""
            cell.imageView?.image = query_image
        } else if indexPath.section == 1 {
            let label = results[indexPath.row]["label"] as! String!
            let score = "\(results[indexPath.row]["score"] as! NSNumber!)"
            let jan  = results[indexPath.row]["jan"] as! String!
            let id  = results[indexPath.row]["id"] as! String!
            cell.textLabel?.text = label
            cell.detailTextLabel!.text =  "スコア：\(score), JAN：\(jan), ID：\(id)"
            let imagePath = results[indexPath.row]["labelImgSrc"] as! String
            let url = imageURL(imagePath)
            cell.imageView?.image = imageFromURL(url)
        }
        return cell
    }

    func imageURL(path:String)->String {
        return RecognitionAPI.apiHost + path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    func imageFromURL(url:String)->UIImage? {
        if ((image_cache[url]) != nil) {
            return (image_cache[url] as! UIImage)
        }
        //NSLog(@"req=%@",url);
        let imageURL = NSURL(string: url)
        let imageData = NSData(contentsOfURL: imageURL!)
        if (imageData == nil){
            //NSLog(@"%@",error);
            return nil;
        }
        let image = UIImage(data:imageData!);
        //NSLog(@"res=%@",image);
        image_cache[url] = image
        return image;
    }

    // Segueで画面遷移するときに呼ばれる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            let next_vc = segue.destinationViewController as! DetailViewController
            next_vc.text = current_text
            next_vc.image = current_image
        }
    }
}
