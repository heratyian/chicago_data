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
let DetailSegueID = "Detail"

// TODO: move plenario functions to plenario convenience
// send center coordinate, populate points

class MapViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var locationManager: CLLocationManager!
    var placemark: MKPlacemark?
    var dataPoint: PlenarioDataPoint?   // sent to detailViewController
    var startDate: Date!
    var endDate: Date!
    
    // MARK: Constants
    let LongitudeDelta = 2200.0
    let LatitudeDelta = 2200.0
    let hardCodedCity = "Chicago, IL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDates()
        initLocationManager()
        self.setLocation(hardCodedCity)
        mapView.delegate = self
    }
    
    
    @IBAction func queryButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: SettingsSegueID, sender: self)
    }
    
    fileprivate func createDates() {
        // create dates
        let todaysDate = Date()
        let thirtyDaysAgo = Date(timeInterval: -2592000.0, since: todaysDate)
        
        startDate = thirtyDaysAgo
        endDate = todaysDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SettingsSegueID {
            
            var settingsVC: SettingsViewController = SettingsViewController()
            settingsVC = segue.destination as! SettingsViewController
            settingsVC.delegate = self
            
            settingsVC.startDate = (self.startDate! as NSDate) as Date!
            settingsVC.endDate = (self.endDate! as NSDate) as Date!
            
            settingsVC.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
            settingsVC.modalPresentationStyle = .overCurrentContext
            
        } else if segue.identifier == DetailSegueID {
            
            var detailViewController: DetailViewController = DetailViewController()
            detailViewController = segue.destination as! DetailViewController
            
            detailViewController.dataPoint = self.dataPoint!
            
            detailViewController.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
            detailViewController.modalPresentationStyle = .overCurrentContext
        }
    }

    fileprivate func queryDatabase(_ start: Date, end: Date) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        self.startDate = start
        self.endDate = end
        
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
    
    fileprivate func createAnnotationWithDataPoint(_ dataPoint: PlenarioDataPoint) {
        // input: PlenarioDataPoint Object
        // create annotation and add it to mapview
        
        let coordinate = CLLocationCoordinate2DMake(dataPoint.latitude, dataPoint.longitude)
        
        let annotation = MyAnnotation()
        annotation.coordinate = coordinate
        annotation.title = dataPoint.primaryType
        annotation.subtitle = dataPoint.description
        annotation.dataPoint = dataPoint
        
        self.mapView.addAnnotation(annotation)

    }
    
}

// MARK: SettingsViewControllerDelegate
extension MapViewController: SettingsViewControllerDelegate {

    func giveStartAndEndDate(_ start: Date, end: Date) {
        queryDatabase(start, end: end)
    }
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped annotation")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tapped accesory buttons")
        
        // fetch datapoint
        let annotation = view.annotation as! MyAnnotation
//        print(annotation.dataPoint!.caseNumber)
        self.dataPoint = annotation.dataPoint!
        
        // segue to detailViewController
        performSegue(withIdentifier: DetailSegueID, sender: self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
        
        return view
    }
}

// MARK: CLLocationManager
extension MapViewController: CLLocationManagerDelegate {
    
    fileprivate func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // TODO: if user location, set to user current location, else chicago downtown
    fileprivate func setLocation(_ city: String) {
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
        }
    }
}

class MyAnnotation: MKPointAnnotation {
    
    override init() {
        super.init()
    }
    
    var dataPoint: PlenarioDataPoint?
    
}

