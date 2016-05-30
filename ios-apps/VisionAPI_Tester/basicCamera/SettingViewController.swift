//
//  SettingViewController.swift
//  basicCamera
//
//  Created by koki on 2016/05/19.
//  Copyright © 2016年 koki. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var txtGoogleKey: UITextField!
    @IBOutlet weak var txtMSKey: UITextField!
    @IBOutlet weak var txtIBMUsername: UITextField!
    @IBOutlet weak var txtIBMPassword: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTextValues()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveTextValues()
        
    }
    
    private func saveTextValues() {
        APIkeys.GoogleKey = txtGoogleKey.text!
        APIkeys.MSKey = txtMSKey.text!
        APIkeys.IBMUname = txtIBMUsername.text!
        APIkeys.IBMPass = txtIBMPassword.text!
        APIkeys.upateKeySettings()
    }
    
    private func loadTextValues() {
        txtGoogleKey.text = APIkeys.GoogleKey
        txtMSKey.text = APIkeys.MSKey
        txtIBMUsername.text = APIkeys.IBMUname
        txtIBMPassword.text = APIkeys.IBMPass
    }
}