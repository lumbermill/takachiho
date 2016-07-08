//
//  ViewController.swift
//  Recognition-Input-app
//
//  Created by koki on 2016/07/08.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var itemList: [[String]] = []
    var currentItemName = ""
    var currentItemJan = ""
    var currentItemId = ""
    
    @IBOutlet weak var ItemPicker: UIPickerView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemJAN: UILabel!
    @IBOutlet var itemImages: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItemList()
        ItemPicker.dataSource = self
        ItemPicker.delegate = self
        itemName.text = ""
        itemJAN.text = ""
        for itemImage in itemImages {
            itemImage.contentMode = UIViewContentMode.ScaleAspectFit
            itemImage.image = UIImage(imageLiteral: "blank.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadItemList() {
        if let csvPath = NSBundle.mainBundle().pathForResource("item_list", ofType: "txt") {
            do {
                let csvString = try NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding) as String
                csvString.enumerateLines { (line, stop) -> () in
                    self.itemList.append(line.componentsSeparatedByString(","))
                }
            } catch {
                print("Loading Item List Failed: Data is Invalid.")
            }
        }
    }
    
    // Picker View の列数=1
    func numberOfComponentsInPickerView(pickerview1: UIPickerView) -> Int {
        return 1
    }
    
    // Picker View の行数=リストの行数
    func pickerView(pickerview1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
        // Picker View で選択されたときに実行する処理
    func pickerView(pickerview: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemName.text =  itemList[row][2]
        itemJAN.text =  "JAN:" + itemList[row][1]
        currentItemId = itemList[row][0]
        currentItemJan = itemList[row][1]
        currentItemName = itemList[row][2]
    }
    
    // Picker View に文字列設定＆フォントサイズ調整
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        pickerLabel.text = itemList[row][2]
        return pickerLabel
    }
}

