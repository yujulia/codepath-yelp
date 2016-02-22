//
//  MapViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    weak var state: YelpState?
    var business: [Business]?
    
    var locationManager : CLLocationManager!

    // ------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        
        self.setupLocationManager()
        self.showBizOnMap()
    }
    
    // ------------------------------------------
    
    private func showBizOnMap() {
        for biz in self.business! {
            let coordinate = CLLocationCoordinate2D(latitude: Double(biz.lat!), longitude: Double(biz.long!))
        
            self.addAnnotationAtCoordinate(coordinate, note: biz.name!)
        }
    }
    
    // ------------------------------------------
    
    private func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, note: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = note
        mapView.addAnnotation(annotation)
    }
    
    // ------------------------------------------
    
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 200
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // ------------------------------------------
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func listIconTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
}

//

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            self.addAnnotationAtCoordinate(location.coordinate, note: "I am here!")
        }
    }
}

