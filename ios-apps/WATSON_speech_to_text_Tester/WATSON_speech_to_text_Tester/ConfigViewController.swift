//
//  ConfigViewController.swift
//  WATSON_speech_to_text_Tester
//
//  Created by koki on 2016/06/10.
//  Copyright © 2016年 koki. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var WATSON_uname: UITextField!
    @IBOutlet weak var WATSON_pass: UITextField!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTextValues()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveTextValues()
        
    }
    
    private func saveTextValues() {
        WATSON_S2TAPI.IBMUname = WATSON_uname.text!
        WATSON_S2TAPI.IBMPass = WATSON_pass.text!
        WATSON_S2TAPI.upateKeySettings()
    }
    
    private func loadTextValues() {
        WATSON_uname.text = WATSON_S2TAPI.IBMUname
        WATSON_pass.text = WATSON_S2TAPI.IBMPass
    }

}