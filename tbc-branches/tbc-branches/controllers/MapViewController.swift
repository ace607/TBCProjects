//
//  MapViewController.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Localize

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedItem: ATMBranch?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var langBtn: UIButton!
    let atmViewModel = ATMViewModel()
    let branchViewModel = BranchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        checkLocationServiceEnabled()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRecieveObject(with:)),
            name: NSNotification.Name("show_pin"),
            object: nil)

        atmViewModel.getObjects { (objects) in
            objects.forEach({ object in
                self.addAnnotation(object: object)
            })
        }
        branchViewModel.getObjects { (objects) in
            objects.forEach({ object in
                self.addAnnotation(object: object)
            })
        }
        langBtn.setImage(Localize.currentLanguage == "en" ? UIImage(named: "img-flag-uk") : UIImage(named: "img-flag-georgia"), for: .normal)

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeLang(with:)),
            name: NSNotification.Name("change_lang"),
            object: nil)
    }
    
    @objc func didRecieveObject(with notification: Notification) {
        
        selectedItem = (notification.userInfo!["selectedObj"] as! ATMBranch)
        centerMapView(lat: Double(selectedItem!.lat)!, lng: Double(selectedItem!.lng)!)
    }
    
    
    @objc func didChangeLang(with notification: Notification) {
        self.mapView.removeAnnotations(mapView.annotations)
        atmViewModel.getObjects { (objects) in
            objects.forEach({ object in
                self.addAnnotation(object: object)
            })
        }
        branchViewModel.getObjects { (objects) in
            objects.forEach({ object in
                self.addAnnotation(object: object)
            })
        }
        self.langBtn.setImage(Localize.currentLanguage == "en" ? UIImage(named: "img-flag-uk") : UIImage(named: "img-flag-georgia"), for: .normal)
        view.layoutIfNeeded()
    }
    
    @IBAction func changeLang(_ sender: UIButton) {
        if langBtn.currentImage == UIImage(named: "img-flag-uk") {
            langBtn.setImage(UIImage(named: "img-flag-georgia"), for: .normal)
            Localize.update(language: "ge")
            NotificationCenter.default.post(name: NSNotification.Name("change_lang"), object: nil)
        } else {
            langBtn.setImage(UIImage(named: "img-flag-uk"), for: .normal)
            Localize.update(language: "en")
            NotificationCenter.default.post(name: NSNotification.Name("change_lang"), object: nil)
        }
    }
    private func checkLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorizationStatus()
        } else {
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .authorizedAlways:
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            print("")
        }
    }
    
    
    private func centerMapView(lat: Double, lng: Double) {
        let mapMeterds: Double = 1_000
        
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), latitudinalMeters: mapMeterds, longitudinalMeters: mapMeterds)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotation(object: ATMBranch?) {
            guard let object = object else {return}
            let lat = Double(object.lat)!
            let lng = Double(object.lng)!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lng)!)
        annotation.title = Localize.currentLanguage == "ge" ? object.nameGe : object.nameEn
        annotation.subtitle = Localize.currentLanguage == "ge" ? object.addressGe : object.addressEn
            
        
            self.mapView.addAnnotation(annotation)
        }

    
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
