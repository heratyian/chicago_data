//
//  ViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit
import GeoJSON
import MapKit

let SettingsSegueID = "Settings"

// TODO: move plenario functions to plenario convenience
// send center coordinate, populate points

class MapViewController: UIViewController, CLLocationManagerDelegate, SettingsViewControllerDelegate {

    /* MARK: Properties */
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var placemark: MKPlacemark?
    var points: [PlenarioDataPoint] = [PlenarioDataPoint]()
    
    /* MARK: Constants */
    let LongitudeDelta = 2200.0
    let LatitudeDelta = 2200.0
    let hardCodedCity = "Chicago, IL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManager()
        
        self.setLocation(hardCodedCity)
    }
    
    // MARK: SettingsViewControllerDelegate
    func giveStartAndEndDate(startDate: NSDate, endDate: NSDate) {
        // TODO: clear old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // query DB with dates
        let centerCoordinate = CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude)
        let latD = self.mapView.region.span.latitudeDelta
        let longD = self.mapView.region.span.longitudeDelta
        
        PlenarioClient.sharedInstance().getPlenarioDataPointsWithTimeframe(centerCoordinate, latitudeDelta: latD, longitudeDelta: longD, startDate: startDate, endDate: endDate, completionHandlerForPlenarioDataPoints: { (points, error) in
            if let error = error {
                print(error)
            } else {
                if let points = points {
                    
                    for point in points {
                        print(point.caseNumber)
                        self.createAnnotationWithDataPoint(point)
                    }
                    
                } else {
                    print("fail")
                }
            }
        })

        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        presentedVC.view.backgroundColor = YOUR_COLOR; // can be with 'alpha'
//        presentingVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//        [presentingVC presentViewController:presentedVC animated:YES completion:NULL];
        
        var settingsVC: SettingsViewController = SettingsViewController()
        settingsVC = segue.destinationViewController as! SettingsViewController
        settingsVC.delegate = self
        
        settingsVC.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        settingsVC.modalPresentationStyle = .OverCurrentContext
    }
    
    @IBAction func queryButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(SettingsSegueID, sender: self)
    }
    

    
    private func queryDatabase() {
        // query plenario api
        
        let centerCoordinate = CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude)
        let latD = self.mapView.region.span.latitudeDelta
        let longD = self.mapView.region.span.longitudeDelta
        
        PlenarioClient.sharedInstance().getPlenarioDataPoints(centerCoordinate, latitudeDelta: latD, longitudeDelta: longD, completionHandlerForPlenarioDataPoints: { (points, error) in
            if let error = error {
                print(error)
            } else {
                if let points = points {
                    //                    self.points = points
                    for point in points {
                        print(point.caseNumber)
                        self.createAnnotationWithDataPoint(point)
                    }
                    
                } else {
                    print("fail")
                }
            }
        })
    }
    
    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // todo: if user location, set to user current location, else chicago downtown
    private func setLocation(city: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {
                print("could not find placemarks")
                return
            }
            
            guard placemarks.count > 0 else {
                print("no results")
                return
            }
            
            let topResult: CLPlacemark = placemarks[0]
            self.placemark = MKPlacemark(placemark: topResult)
            
            var region: MKCoordinateRegion = self.mapView.region
            region.center = (self.placemark!.location?.coordinate)!
            region.span.longitudeDelta /= self.LongitudeDelta
            region.span.latitudeDelta /= self.LatitudeDelta
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(self.placemark!)
        }
        
        
    }
    
    private func createAnnotationWithDataPoint(dataPoint: PlenarioDataPoint) {
        // input: PlenarioDataPoint Object
        // create annotation and add it to mapview
        
        let coordinate = CLLocationCoordinate2DMake(dataPoint.latitude, dataPoint.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = dataPoint.primaryType
        annotation.subtitle = dataPoint.description
        self.mapView.addAnnotation(annotation)

    }
}

