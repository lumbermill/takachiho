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

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let lm = CLLocationManager()
    var current = MKPointAnnotation()
    var current_spot: Point?
    var need_update_center = true
    let points = Points.sharedInstance

    override func viewDidLoad() -> Void {
        // MapView
        var cr = mapView.region
        cr.center = CLLocationCoordinate2DMake(32.709981,131.308574) // 452
        cr.span = MKCoordinateSpanMake(0.05, 0.05)
        mapView.setRegion(cr, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(current)
        
        
        // Pins
        for p in points.array{
            addPoint(p)
        }
        
        // LocationManager
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        
    }
    
    
    func addPoint(point: Point){
        let pa = MKPointAnnotation()
        pa.coordinate = CLLocationCoordinate2DMake(point.lat,point.lng)
        pa.title = point.name
        pa.subtitle = point.kanji
        mapView.addAnnotation(pa)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            current.coordinate = l.coordinate
            if(need_update_center){
                let cr = MKCoordinateRegionMake(l.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                mapView.setRegion(cr, animated: true)
                need_update_center = false
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isEqual(current)){
            if let av = mapView.dequeueReusableAnnotationViewWithIdentifier("center") {
                av.annotation = annotation
                return av;
            }else{
                let av = MKAnnotationView(annotation: annotation, reuseIdentifier: "center")
                av.image = UIImage(named: "Center")
                av.annotation = annotation
                return av;
            }
        } else if (points.is_visited(annotation.title!)) {
            if let av = mapView.dequeueReusableAnnotationViewWithIdentifier("pin-visited"){
                av.annotation = annotation
                //av.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "Question"))
                // 画像出したいけど、重たそう…？
                return av;
            }else{
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin-visited")
                av.pinTintColor = UIColor.brownColor()
                av.canShowCallout = true
                //av.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "Question"))
                return av;
            }
        }else{
            if let av = mapView.dequeueReusableAnnotationViewWithIdentifier("pin"){
                av.annotation = annotation
                return av;
            }else{
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                av.pinTintColor = UIColor.blueColor()
                av.canShowCallout = true
                let b = UIButton(frame: CGRectMake(0,0,32,32))
                b.setImage(UIImage(named: "Camera"), forState: UIControlState.Normal)
                av.rightCalloutAccessoryView = b
                return av;
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let a = view.annotation else {
            return
        }
        guard let title = a.title! else {
            return
        }
        print("Showing camera for "+title)
        current_spot = points.dictionary[title]

        // ImagePicker(Camera)
        let ipc = UIImagePickerController() // TODO: サブクラス必要？効果なし
        ipc.delegate = self
        if (Utils.isSimulator()){
            ipc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        }else{
            ipc.sourceType = UIImagePickerControllerSourceType.Camera
            ipc.allowsEditing = false
            ipc.showsCameraControls = false
            let sh = UIScreen.mainScreen().bounds.height // screen height
            let ch = UIScreen.mainScreen().bounds.width / 3 * 4
            ipc.cameraViewTransform.ty = (sh - ch) / 2.0;
            let ov = OverlayView(name: current_spot?.name, imagePicker: ipc)
            ov.imagePicker = ipc
            ipc.cameraOverlayView = ov
            //ipc. 正方形固定、ビューをオーバラップする。
        }
        let cd = UIDevice.currentDevice()
        while(cd.generatesDeviceOrientationNotifications){
            cd.endGeneratingDeviceOrientationNotifications()
        }
        self.presentViewController(ipc, animated: true, completion: {})
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
        points.dictionary[p.name]!.visited = true
//        picker.dismissViewControllerAnimated(true, completion: {
//            let cd = UIDevice.currentDevice()
//            while(!cd.generatesDeviceOrientationNotifications){
//                cd.beginGeneratingDeviceOrientationNotifications()
//            }
//        })
        for a in mapView.selectedAnnotations {
            mapView.deselectAnnotation(a, animated: true)
            mapView.removeAnnotation(a)
            mapView.addAnnotation(a)
        }
        // TODO: 撮った写真が保存される感じをどうやって出そう？
    }
    
    @IBAction func targetButtonPushed(sender: AnyObject) {
        need_update_center = true
    }
}