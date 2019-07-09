//
//  MainViewController.swift
//  09-b-eater
//
//  Created by Yosei Ito on 2019/07/08.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var highscoreLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        let score = ud.integer(forKey: "highscore")
        highscoreLabel.text = "Highscore: \(score)"
    }
}
