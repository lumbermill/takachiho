//
//  ViewController.swift
//  Recognition-Input-app
//
//  Created by koki on 2016/07/08.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var itemList: [[String]] = []
    var currentItemName = ""
    var currentItemJan = ""
    var currentItemId = ""
    var CurrentItemImageIndex = 0
    
    @IBOutlet weak var ItemPicker: UIPickerView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemJAN: UILabel!
    @IBOutlet var itemImages: [UIImageView]!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnSend: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        clearInput()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadItemList() {
        itemList.append(["","",""]) //未選択状態を表す選択肢
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

    func clearInput() {
        loadItemList()
        ItemPicker.dataSource = self
        ItemPicker.delegate = self
        itemName.text =  "商品を選択して下さい。"
        itemJAN.text = ""
        for itemImage in itemImages {
            itemImage.contentMode = UIViewContentMode.ScaleAspectFit
            itemImage.image = UIImage(imageLiteral: "blank.png")
        }
        btnSend.enabled = false
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
        if (itemList[row][0] != "") {
            itemName.text =  itemList[row][2]
            itemJAN.text =  "JAN:" + itemList[row][1]
            currentItemId = itemList[row][0]
            currentItemJan = itemList[row][1]
            currentItemName = itemList[row][2]
        } else {
            itemName.text =  "商品を選択して下さい。"
            itemJAN.text = ""
            currentItemId = ""
            currentItemJan = ""
            currentItemName = ""
        }
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

    @IBAction func pushBtnCamera(sender: AnyObject) {
        cameraStart(self)
    }
    
    func cameraStart(sender: AnyObject) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            btnCamera.enabled = false
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }
        else{
            btnCamera.enabled = true
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        btnCamera.enabled = true
        itemImages[CurrentItemImageIndex].image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (CurrentItemImageIndex < itemImages.count - 1) {
            CurrentItemImageIndex += 1
        } else {
            CurrentItemImageIndex = 0
            btnCamera.enabled = false
            btnSend.enabled = true
        }
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        btnCamera.enabled = true
    }
    
    @IBAction func pushBtnSend(sender: AnyObject) {
        showAlert("画像をアップロードしました。", message: nil)
        clearInput()
        btnCamera.enabled = true
    }
    
    func showAlert(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

