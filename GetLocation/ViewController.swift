//
//  ViewController.swift
//  GetLocation
//
//  Created by Shengjie Mao on 10/20/23.
//

import UIKit
import CoreLocation

/*
 1. In Info.plist add a new role and select "Privacy Location Always and when in use and add a description"
 2. In View controller import CoreLocation
 3. Create UI elements and create outlets
 4. Implement CLLocationManagerDelegate in the class
 5. Add an instance of location Manager
 6. in viewidload add delegate to self and accuracy
 7-8. add locationManager function of didUpdateLocations and didFailWithError function
 9. if want get address write a function which uses CLGeocoder and get the reversed address
 10. if want update location automatically, use significantLocationChangeMonitoringAvailable function
 */

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblLatitude: UILabel!
    
    @IBOutlet weak var lblLongitude: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign delegate
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // request location whenever the app is in usage. sequence here matters
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        startSignificantChangeLocation()
    }

    @IBAction func getLocationAction(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    func startSignificantChangeLocation() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let lat = location.coordinate.latitude;
        let lng = location.coordinate.longitude;
        
        print("Latitude = \(lat)")
        print("Longitude = \(lng)")
        
        lblLatitude.text = "Latitude = \(lat)"
        lblLongitude.text = "Longitude = \(lng)"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error in getting location = \(error.localizedDescription)")
    }
    
    func getLocationAddress(location: CLLocation) {
        let clGeoCoder = CLGeocoder()
        
        clGeoCoder.reverseGeocodeLocation(location) { clPlaceMarks, error in
            if error != nil {
                print("Error in getting location from GeoCoder \(error?.localizedDescription)")
                return
            }
            
            guard let place = clPlaceMarks?.last else {return} // the "?" means optional
            var address = ""
            print(place.name)
            print(place.locality)
            print(place.postalCode)
            print(place.subAdministrativeArea)
            print(place.subLocality)
        }
    }
    
}

