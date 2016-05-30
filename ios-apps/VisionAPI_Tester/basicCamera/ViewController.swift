//
//  ViewController.swift
//  basicCamera
//
//  Created by koki on 2016/05/15.
//  Copyright © 2016年 koki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var scrollText: UITextView!
    
    @IBOutlet weak var bCameraStart: UIBarButtonItem!
    @IBOutlet weak var bGoogle: UIBarButtonItem!
    @IBOutlet weak var bMS: UIBarButtonItem!
    @IBOutlet weak var bIBM: UIBarButtonItem!
    @IBOutlet weak var bSetting: UIBarButtonItem!
    @IBOutlet weak var label: UILabel!

    enum API{
        case None
        case Google
        case MS
        case IBM
    }
    var current_result:API = API.None
    let r_google = GoogleRequest()
    let r_ms_v = MSVisualFeaturesRequest()
    let r_ms_d = MSDescriveRequest()
    let r_ibm = IBMRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIkeys.LoadKeySettings()
        current_result = API.None
        bGoogle.enabled = false
        bMS.enabled = false
        bIBM.enabled = false
        label.text = "カメラアイコンをタップして写真を撮ると自動的にAPIに問い合わせます"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initLayer()
    }
    
    @IBAction func cameraStart(sender: AnyObject) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self

            current_result = API.None
            bGoogle.enabled = false
            bMS.enabled = false
            bIBM.enabled = false
            clearFaceRect()
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }
        else{
            label.text = "error. No Camera."
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraView.contentMode = .ScaleAspectFit
            cameraView.image = pickedImage
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                self.r_google.send(pickedImage, callback: {_,_,_ in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.bGoogle.enabled = true
                        self.label.text = ""
                    }
                })
                var ms_req_comp = false
                self.r_ms_v.send(pickedImage, callback: {_,_,_ in
                    dispatch_async(dispatch_get_main_queue()) {
                        if (ms_req_comp) {
                            self.bMS.enabled = true
                            self.label.text = ""
                        } else {
                            ms_req_comp = true
                        }
                    }
                })
                self.r_ms_d.send(pickedImage, callback: {_,_,_ in
                    dispatch_async(dispatch_get_main_queue()) {
                        if (ms_req_comp) {
                            self.bMS.enabled = true
                            self.label.text = ""
                        } else {
                            ms_req_comp = true
                        }
                    }
                })
                self.r_ibm.send(pickedImage, callback: {_,_,_ in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.bIBM.enabled = true
                        self.label.text = ""
                    }
                })
            })
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        label.text = "APIに問い合わせ中.."
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        label.text = "Canceled"
    }
    
    @IBAction func showResultGoogle(sender: AnyObject) {
        toggleLayer(API.Google, text: r_google.result)
        clearFaceRect()
        let face_layers = r_google.faceRectLayers(cameraView)
        drawFaceRect(face_layers)
    }
    
    @IBAction func showResultMS(sender: AnyObject) {
        toggleLayer(API.MS, text: r_ms_v.result + "\n" + r_ms_d.result)
        clearFaceRect()
        let face_layers = r_ms_v.faceRectLayers(cameraView)
        drawFaceRect(face_layers)
    }

    @IBAction func showResultIBM(sender: AnyObject) {
        toggleLayer(API.IBM, text: r_ibm.result)
        clearFaceRect()
    }
    
    private func drawFaceRect(face_layers:Array<UIView>?) {
        if face_layers == nil {
            return
        }
        face_layers!.forEach{layer in
            cameraView.addSubview(layer)
        }
    }
    private func clearFaceRect() {
        cameraView.subviews.forEach{subview in
            subview.removeFromSuperview()
        }
    }
    
    private func toggleLayer(api_type:API, text:String) {
        if current_result == api_type {
            hideLayer()
            markActiveButton(API.None)
            current_result = API.None
        } else {
            showLayer(text)
            markActiveButton(api_type)
            current_result = api_type
        }
    }
    
    private func markActiveButton(api_type:API) {
        bGoogle.tintColor = bCameraStart.tintColor
        bMS.tintColor = bCameraStart.tintColor
        bIBM.tintColor = bCameraStart.tintColor
        switch api_type {
        case API.Google:
            bGoogle.tintColor = UIColor.redColor()
        case API.MS:
            bMS.tintColor = UIColor.redColor()
        case API.IBM:
            bIBM.tintColor = UIColor.redColor()
        default:
            break
        }
    }
    
    func initLayer() {
        scrollText.editable = false
        scrollText.hidden = true
        current_result = API.None
        markActiveButton(API.None)
    }
    
    func showLayer(text:String) {
        scrollText.text = text
        scrollText.hidden = false
    }
    
    func hideLayer() {
        scrollText.hidden = true
    }
    
    @IBAction func unwindToTop(segue:UIStoryboardSegue) {} // 別画面からの戻り用
}

