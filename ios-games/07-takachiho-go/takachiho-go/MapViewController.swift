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
    let ipc = UIImagePickerController()
    var current_spot: Point?
    var need_update_center = true
    let points = Points.sharedInstance
    #if DEBUG
    let radius:CLLocationDistance = 10050.0
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
        
        // ImagePickerController
        // ImagePicker(Camera)
        if (Utils.isSimulator()){
            ipc.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }else{
            ipc.sourceType = UIImagePickerControllerSourceType.camera
            ipc.allowsEditing = false
            ipc.showsCameraControls = false
            // FIXME: iOS10の不具合かビューが移動しない。 https://forums.developer.apple.com/thread/60888
            ipc.cameraViewTransform.ty = Utils.getCameraViewTransformY()
            let ov = OverlayView(name: current_spot?.name, imagePicker: ipc,controller: self)
            ov.imagePicker = ipc
            ipc.cameraOverlayView = ov
        }

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
                if let vc = UIApplication.shared.delegate?.window??.rootViewController {
                    vc.present(viewController!, animated: true, completion: nil)
                }
            } else {
                // print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("memory warning!!")
    }

    func addPoint(_ point: Point){
        let pa = MKPointAnnotation()
        pa.coordinate = CLLocationCoordinate2DMake(point.lat,point.lng)
        pa.title = point.name
        pa.subtitle = point.kanji
        mapView.addAnnotation(pa)
        let c:MKCircle = MKCircle(center: pa.coordinate, radius: radius)
        c.title = point.name
        mapView.add(c)
//        // Up to 20 points.
//        let r = CLCircularRegion(center: pa.coordinate, radius: radius, identifier: point.name)
//        r.notifyOnEntry = true
//        lm.startMonitoringForRegion(r)
//        // print(CLLocationManager.isMonitoringAvailableForClass(r))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            if(need_update_center){
                let cr = MKCoordinateRegionMake(l.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                mapView.setRegion(cr, animated: true)
                need_update_center = false
                targetButton.isEnabled = true
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

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title else {
            return nil
        }
        guard let p = points.dictionary[title!] else {
            return nil
        }
        if (annotation.isKind(of: MKUserLocation.self)){
            return nil
        }else if(p.has_webcam()){
            if(p.visited){
                if let av = mapView.dequeueReusableAnnotationView(withIdentifier: "webcam-visited"){
                    av.annotation = annotation
                    return av
                }else{
                    let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "webcam-visited")
                    av.pinTintColor = UIColor.brown // Change color of visited pins.
                    av.canShowCallout = true
                    let b = UIButton(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
                    b.setImage(UIImage(named: "Webcam"), for: UIControlState())
                    av.rightCalloutAccessoryView = b
                    return av
                }
            }else{
                if let av = mapView.dequeueReusableAnnotationView(withIdentifier: "webcam"){
                    av.annotation = annotation
                    return av
                }else{
                    let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "webcam")
                    av.pinTintColor = UIColor(red:0.0, green: 0.60, blue: 0.0, alpha: 1.0)
                    av.canShowCallout = true
                    let b = UIButton(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
                    b.setImage(UIImage(named: "Webcam"), for: UIControlState())
                    av.rightCalloutAccessoryView = b
                    return av
                }
            }
        }else{
            // camera
            var name = "camera-visited"
            var color = UIColor.brown
            if(!p.visited){
                if(p.difficulty == 1){
                    name = "camera-d1"
                    color = UIColor(red: 0.54, green: 0.81, blue: 0.88, alpha: 1.0)
                }else if(p.difficulty == 2){
                    name = "camera-d2"
                    color = UIColor(red: 0.20, green: 0.73, blue: 0.89, alpha: 1.0)
                }else if(p.difficulty == 3){
                    name = "camera-d3"
                    color = UIColor(red: 0.01, green: 0.43, blue: 0.72, alpha: 1.0)
                }
            }
            if let av = mapView.dequeueReusableAnnotationView(withIdentifier: name){
                av.annotation = annotation
                return av
            }else{
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: name)
                av.pinTintColor = color // Change color of visited pins.
                av.canShowCallout = true
                let b = UIButton(frame: CGRect(x: 0,y: 0,width: 32,height: 32))
                b.setImage(UIImage(named: "Camera"), for: UIControlState())
                av.rightCalloutAccessoryView = b
                return av
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let c = overlay as? MKCircle {
            if(points.is_visited(c.title!)){
                return MKOverlayRenderer()
            }
            let cv = MKCircleRenderer(circle: c)
            cv.fillColor = UIColor.lightGray
            cv.alpha = 0.2
            return cv
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
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
            current_spot = points.dictionary[title]
            if(current_spot == nil){
                print("can't find point for "+title)
                return
            }
            if (current_spot!.has_webcam()){
                print("Showing webcam view for "+title)
                self.performSegue(withIdentifier: "wvc", sender: self)
            }else{
                print("Showing camera for "+title)
                if let ov :OverlayView = ipc.cameraOverlayView as? OverlayView {
                    if let name = current_spot?.name {
                        ov.reset(name: name)
                        ov.updateGodImage()
                    }
                }
                self.present(ipc, animated: true, completion: {
                    // workaround for iOS10
                    self.ipc.cameraViewTransform.ty = Utils.getCameraViewTransformY()
                })
            }
        }else{
            let ac = UIAlertController(title: nil, message: "Too far to take picture.", preferredStyle: UIAlertControllerStyle.alert)
            //let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            //ac.addAction(aa)
            self.present(ac, animated: true, completion: { () -> Void in
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    // Webcamの写真を撮った後の処理
    func updateForWebcam(_ success: Bool){
        self.points.load() // Pointがクラスでなく構造体なので、この瞬間にロードしなおさないとうまくいかない…
        for a in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(a, animated: true)
            self.mapView.removeAnnotation(a)
            self.mapView.addAnnotation(a)
        }
        var title = "Gotcha!"
        if(!success){
            title = "Failed to save..."
        }
        let ac = UIAlertController(title: title, message: "You've taken a photo from the sky.", preferredStyle: UIAlertControllerStyle.alert)
        let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        ac.addAction(aa)
        self.present(ac, animated: true, completion: nil)
    }
    
    func updateForCamera(_ success: Bool){
        guard let p = current_spot else {
            print("current_spot is not set")
            return
        }
        for a in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(a, animated: true)
            self.mapView.removeAnnotation(a)
            self.mapView.addAnnotation(a)
        }
        var title = "Gotcha!"
        if(!success){
            title = "Failed to save..."
        }
        let n = self.points.n_visited()
        let total = self.points.array.count
        let ac = UIAlertController(title: title, message: "You've taken \(n) of \(total) sacred photos.", preferredStyle: UIAlertControllerStyle.alert)
        let aa = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        ac.addAction(aa)
        self.present(ac, animated: true, completion: nil)
        if (self.points.is_achieved(p.difficulty)) {
            // Achieve all in the level.
            self.reportAcheivement(p.difficulty)
        } else if (n == 1) {
            // First taken!
            self.reportAcheivement(0)
        }
        self.reportScore("grp.tg.shrines",score: n)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        guard let p = current_spot else {
            print("current_spot is not set")
            return
        }
        // print("begin writing image data.")
        DispatchQueue.global().async {
            var b = false
            if let d = UIImageJPEGRepresentation(image, 1.0) {
                do{
                    try d.write(to: URL(fileURLWithPath: p.path_for_photo(thumb: false)), options: [.atomic])
                    let _ = p.create_thumbnail()
                    b = true
                }catch {
                }
            }
            if var v = self.points.dictionary[p.name] {
                v.visited = true
                v.visited_at = Date()
            }
            self.points.load() // Pointがクラスでなく構造体なので、この瞬間にロードしなおさないとうまくいかない…
            Gods.sharedInstance.load() // 神様もフラグ更新
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: {
                    self.updateForCamera(b)
                })
            }
        }
    }

    func reportScore(_ id: String, score: Int){
        if (!GKLocalPlayer.localPlayer().isAuthenticated) { return }
        let s = GKScore(leaderboardIdentifier: id) // Leaderboard ID
        s.value = Int64(score)
        // NSLog("Reporting scores %@",s)
        #if DEBUG
            // do nothing.
        #else
        GKScore.report([s], withCompletionHandler: {(error: Error?) -> Void in
            if let e = error{
                print(e)
            }
        })
        #endif
    }

    func reportAcheivement(_ difficulty:(Int)){
        if (!GKLocalPlayer.localPlayer().isAuthenticated) { return }
        var id = "grp.tg.first"
        if (difficulty >= 1 && difficulty <= 3){
            id = "grp.tg.level"+String(difficulty)
        }
        let a = GKAchievement(identifier: id)
        a.percentComplete = 100.0
        GKAchievement.report([a], withCompletionHandler: {(error: Error?) -> Void in
            if let e = error{
                print(e)
            }
        })
    }

    @IBAction func targetButtonPushed(_ sender: AnyObject) {
        need_update_center = true
        targetButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wvc" {
            guard let wvc:WebcamViewController = (segue.destination as? WebcamViewController) else {
                return
            }
            wvc.controller = self
            wvc.point = current_spot
        }
    }
}
