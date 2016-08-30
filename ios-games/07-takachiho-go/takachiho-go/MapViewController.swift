//
//  MapViewController.swift
//  takachiho-go
//
//  Created by Yosei Ito on 7/22/16.
//  Copyright © 2016 LumberMill. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GameKit

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var targetButton: UIButton!
    let lm = CLLocationManager()
    var current_spot: Point?
    var need_update_center = true
    let points = Points.sharedInstance
    #if DEBUG
    let radius:CLLocationDistance = 1550.0 // Sacrid circle radius(meter).
    #else
    let radius:CLLocationDistance = 50.0 // Sacrid circle radius(meter).
    #endif

    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        // MapView
        var cr = mapView.region
        cr.center = CLLocationCoordinate2DMake(32.709981,131.308574) // 452
        cr.span = MKCoordinateSpanMake(0.05, 0.05)
        mapView.setRegion(cr, animated: true)
        mapView.removeAnnotations(mapView.annotations)

        // LocationManager
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()

        // Pins
        for p in points.array{
            addPoint(p)
        }
        authPlayer()
    }

    func authPlayer(){
        let p = GKLocalPlayer.localPlayer()
        p.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil){
                if let vc = UIApplication.sharedApplication().delegate?.window??.rootViewController {
                    vc.presentViewController(viewController!, animated: true, completion: nil)
                }
            } else {
                NSLog("%d",GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }

    func addPoint(point: Point){
        let pa = MKPointAnnotation()
        pa.coordinate = CLLocationCoordinate2DMake(point.lat,point.lng)
        pa.title = point.name
        pa.subtitle = point.kanji
        mapView.addAnnotation(pa)
        let c:MKCircle = MKCircle(centerCoordinate: pa.coordinate, radius: radius)
        c.title = point.name
        mapView.addOverlay(c)
//        // Up to 20 points.
//        let r = CLCircularRegion(center: pa.coordinate, radius: radius, identifier: point.name)
//        r.notifyOnEntry = true
//        lm.startMonitoringForRegion(r)
//        // print(CLLocationManager.isMonitoringAvailableForClass(r))
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            if(need_update_center){
                let cr = MKCoordinateRegionMake(l.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                mapView.setRegion(cr, animated: true)
                need_update_center = false
                targetButton.enabled = true
            }
        }
    }

// 何故か反応しない
//    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
//        print(state)
//        print(region)
//    }
//
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("Enter!")
//        let ac = UIAlertController(title: "Enter", message: region.identifier, preferredStyle: UIAlertControllerStyle.Alert)
//        let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//        ac.addAction(aa)
//        self.presentViewController(ac, animated: true, completion: {})
//    }
//
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        print("Exit!")
//        let ac = UIAlertController(title: "Exit", message: region.identifier, preferredStyle: UIAlertControllerStyle.Alert)
//        let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//        ac.addAction(aa)
//        self.presentViewController(ac, animated: true, completion: {})
//   }

    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        } else if (points.is_visited(annotation.title!)) {
            if let av = mapView.dequeueReusableAnnotationViewWithIdentifier("pin-visited"){
                av.annotation = annotation
                return av
            }else{
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin-visited")
                av.pinTintColor = UIColor.brownColor() // Change color of visited pins.
                av.canShowCallout = true
                let b = UIButton(frame: CGRectMake(0,0,32,32))
                b.setImage(UIImage(named: "Camera"), forState: UIControlState.Normal)
                av.rightCalloutAccessoryView = b
                return av
            }
        }else{
            if let av = mapView.dequeueReusableAnnotationViewWithIdentifier("pin"){
                av.annotation = annotation
                return av
            }else{
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                av.pinTintColor = UIColor.blueColor()
                av.canShowCallout = true
                let b = UIButton(frame: CGRectMake(0,0,32,32))
                b.setImage(UIImage(named: "Camera"), forState: UIControlState.Normal)
                av.rightCalloutAccessoryView = b
                return av
            }
        }
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let c = overlay as? MKCircle {
            if(points.is_visited(c.title!)){
                return MKOverlayRenderer()
            }
            let cv = MKCircleRenderer(circle: c)
            cv.fillColor = UIColor.lightGrayColor()
            cv.alpha = 0.2
            return cv
        }
        return MKOverlayRenderer()
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // コールアウト（カメラアイコン）がタップされた時
        guard let a = view.annotation else {
            return
        }
        guard let title = a.title! else {
            return
        }

        let c1 = MKMapPointForCoordinate(mapView.userLocation.coordinate)
        let c2 = MKMapPointForCoordinate(view.annotation!.coordinate)

        let d = MKMetersBetweenMapPoints(c1, c2)

        if (d < radius){
            print("Showing camera for "+title)
            current_spot = points.dictionary[title]

            // ImagePicker(Camera)
            let ipc = UIImagePickerController()
            if (Utils.isSimulator()){
                ipc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            }else{
                ipc.sourceType = UIImagePickerControllerSourceType.Camera
                ipc.allowsEditing = false
                ipc.showsCameraControls = false
                let sh = UIScreen.mainScreen().bounds.height // screen height
                let ch = UIScreen.mainScreen().bounds.width
                if (sh > ch){
                    ipc.cameraViewTransform.ty = (sh - ch / 3 * 4) / 2.0;
                } else{
                    ipc.cameraViewTransform.ty = (ch - sh / 3 * 4) / 2.0;
                }
                let ov = OverlayView(name: current_spot?.name, imagePicker: ipc,controller: self)
                ov.imagePicker = ipc
                ipc.cameraOverlayView = ov
            }
            self.presentViewController(ipc, animated: true, completion: {})
        }else{
            let ac = UIAlertController(title: nil, message: "Too far to take picture.", preferredStyle: UIAlertControllerStyle.Alert)
            //let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            //ac.addAction(aa)
            self.presentViewController(ac, animated: true, completion: { () -> Void in
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        guard let p = current_spot else {
            print("current_spot is not set")
            return
        }
        guard let d = UIImageJPEGRepresentation(image, 1.0) else {
            return
        }
        print("begin writing image data.")
        d.writeToFile(p.path_for_photo(), atomically: true)
        if var v = points.dictionary[p.name] {
            v.visited = true
            v.visited_at = NSDate()
        }
        points.load() // Pointがクラスでなく構造体なので、この瞬間にロードしなおさないとうまくいかない…
        picker.dismissViewControllerAnimated(true, completion: {
            for a in self.mapView.selectedAnnotations {
                self.mapView.deselectAnnotation(a, animated: true)
                self.mapView.removeAnnotation(a)
                self.mapView.addAnnotation(a)
            }

            let n = self.points.n_visited()
            let total = self.points.array.count
            let ac = UIAlertController(title: "Gotcha!", message: "You've taken \(n) of \(total) sacred photos.", preferredStyle: UIAlertControllerStyle.Alert)
            let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            ac.addAction(aa)
            self.presentViewController(ac, animated: true, completion: nil)
            if (self.points.is_achieved(p.difficulty)) {
                // Achieve all in the level.
                self.reportAcheivement(p.difficulty)
            } else if (n == 1) {
                // First taken!
                self.reportAcheivement(0)
            }
            self.reportScore("grp.tg.visits",score: n)
        })
    }

    func reportScore(id: String, score: Int){
        if (!GKLocalPlayer.localPlayer().authenticated) { return }
        let s = GKScore(leaderboardIdentifier: id) // Leaderboard ID
        s.value = Int64(score)
        NSLog("Reporting scores %@",s)
        #if DEBUG
            // do nothing.
        #else
        GKScore.reportScores([s], withCompletionHandler: {(error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
        })
        #endif
    }

    func reportAcheivement(difficulty:(Int)){
        if (!GKLocalPlayer.localPlayer().authenticated) { return }
        var id = "grp.tg.first"
        if (difficulty >= 1 && difficulty <= 3){
            id = "grp.tg.level"+String(difficulty)
        }
        let a = GKAchievement(identifier: id)
        a.percentComplete = 100.0
        GKAchievement.reportAchievements([a], withCompletionHandler: {(error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
        })
    }

    @IBAction func targetButtonPushed(sender: AnyObject) {
        need_update_center = true
        targetButton.enabled = false
    }
}
