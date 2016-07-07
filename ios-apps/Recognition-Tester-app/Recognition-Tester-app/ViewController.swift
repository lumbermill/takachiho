//
//  ViewController.swift
//  Recognition-Tester-app
//
//  Created by koki on 2016/07/05.
//  Copyright © 2016年 LumberMill, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    @IBOutlet weak var btnNext: UIBarButtonItem! //デバッグ用
    
    
    var api: RecognitionAPI?
    var queryImage: UIImage?
    let debug = false // for debug
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // for debug
        if (debug) {
            btnNext.title = "Next"
            btnNext.enabled = true
        } else {
            btnNext.title = ""
            btnNext.enabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushCameraButton(sender: AnyObject) {
        cameraStart(self)
    }
    
    // for debug
    @IBAction func pushButtonNext(sender: AnyObject) {
        queryImage = UIImage(named: "debug.jpg")
        api = RecognitionAPI()
        api?.result_dict = [
            "results":[
                ["id":"1", "jan":"1234567890123","label":"Juice",     "labelImgSrc":"/label-image/1.jpg","score":100],
                ["id":"2", "jan":"1234567890123","label":"riquer",    "labelImgSrc":"/label-image/2.jpg","score":200],
                ["id":"3", "jan":"1234567890123","label":"soy source","labelImgSrc":"/label-image/3.jpg","score":300],
                ["id":"4", "jan":"1234567890123","label":"water1",     "labelImgSrc":"/label-image/4.jpg","score":400],
                ["id":"5", "jan":"1234567890123","label":"water2",     "labelImgSrc":"/label-image/5.jpg","score":400],
                ["id":"6", "jan":"1234567890123","label":"water3",     "labelImgSrc":"/label-image/6.jpg","score":400],
                ["id":"8", "jan":"1234567890123","label":"water4",     "labelImgSrc":"/label-image/7.jpg","score":400],
                ["id":"9", "jan":"1234567890123","label":"water5",     "labelImgSrc":"/label-image/8.jpg","score":400],
                ["id":"10","jan":"1234567890123","label":"water6",     "labelImgSrc":"/label-image/9.jpg","score":400],
                ["id":"11","jan":"1234567890123","label":"water7",     "labelImgSrc":"/label-image/10.jpg","score":400],
                ["id":"12","jan":"1234567890123","label":"water8",     "labelImgSrc":"/label-image/11.jpg","score":400],
                ["id":"13","jan":"1234567890123","label":"water9",     "labelImgSrc":"/label-image/12.jpg","score":400],
                ["id":"14","jan":"1234567890123","label":"water10",     "labelImgSrc":"/label-image/13.jpg","score":400],
                ["id":"15","jan":"1234567890123","label":"water11",     "labelImgSrc":"/label-image/14.jpg","score":400],
                ["id":"16","jan":"1234567890123","label":"water12",     "labelImgSrc":"/label-image/15.jpg","score":400],
                ["id":"17","jan":"1234567890123","label":"water13",     "labelImgSrc":"/label-image/16.jpg","score":400],
                ["id":"18","jan":"1234567890123","label":"長ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーい商品名","labelImgSrc":"/label-image/17.jpg","score":400],
            ],
            "time":500
        ]
        self.performSegueWithIdentifier("showResult", sender: self)
    }
    
    @IBAction func back(segue:UIStoryboardSegue){//戻るボタン用
        print("back")
        lblInfo.text = "カメラを起動して商品を撮影して下さい"
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
            
            lblInfo.text = "撮影中.."
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }
        else{
            lblInfo.text = "カメラが使用できません"
            btnCamera.enabled = true
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        queryImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (queryImage != nil) {
            // APIに問い合わせる
            api = RecognitionAPI()
            api!.send(queryImage!, callback: {_, _, _ in
                dispatch_async(dispatch_get_main_queue()) {
                    // 問い合わせ終了後
                    self.btnCamera.enabled = true
                    print(self.api!.result)
                    if (!self.api!.error) {
                        self.lblInfo.text = "APIからデータを取得しました。結果を表示します"
                        // 結果一覧画面へ
                        self.performSegueWithIdentifier("showResult", sender: self)
                    } else {
                        self.lblInfo.text = "APIへの問い合わせでエラーが発生しました"
                    }
                }
            })
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        lblInfo.text = "APIに問い合わせ中.."
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        lblInfo.text = "撮影がキャンセルされました"
        btnCamera.enabled = true // 問い合わせ終了後
    }
    
    // Segueで画面遷移するときに呼ばれる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let next_vc = segue.destinationViewController as! ResultTableViewController
        next_vc.api_result_dict = api!.result_dict
        next_vc.query_image = queryImage!
    }    
}

