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

        Place.load(completion: { (places) in
            for place in places {
                let pa = MKPointAnnotation()
                pa.coordinate = CLLocationCoordinate2DMake(place.lat,place.lng)
                pa.title = place.name
                // pa.subtitle = point.kanji
                self.mapView.addAnnotation(pa)
            }
        })
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
                let cr = MKCoordinateRegion.init(center: l.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05))
                mapView.setRegion(cr, animated: true)
                targetButton.isEnabled = true
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let av = mapView.dequeueReusableAnnotationView(withIdentifier: "place"){
            av.annotation = annotation
            return av
        }else{
            let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "place")
            av.pinTintColor = UIColor.brown
            av.canShowCallout = true
            return av
        }
    }

    @IBAction func targetButtonPushed(_ sender: AnyObject) {
        targetButton.isEnabled = false
    }
}
