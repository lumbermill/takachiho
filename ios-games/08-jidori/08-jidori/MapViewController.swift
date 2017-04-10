//
//  FirstViewController.swift
//  08-jidori
//
//  Created by Yosei Ito on 2017/03/30.
//  Copyright © 2017 LumberMill. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var targetButton: UIButton!
    let lm = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lm.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            if(targetButton.isEnabled == false){
                let cr = MKCoordinateRegionMake(l.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                mapView.setRegion(cr, animated: true)
                targetButton.isEnabled = true
            }
        }
    }

    @IBAction func targetButtonPushed(_ sender: AnyObject) {
        targetButton.isEnabled = false
    }

}

