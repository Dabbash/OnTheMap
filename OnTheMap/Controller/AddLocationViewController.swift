//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 04/07/2021.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCoordinate(addressString: "Huntsvilla, Alabama") { <#CLLocationCoordinate2D#>, <#NSError?#> in
            <#code#>
        }
    }
    
    /*
    func getLocation() {
        
        let annotation = MKPointAnnotation()
        
        var pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String?)
        
        self.mapView.setCenter(pin.coordinate, animated: true)
        let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    */
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
}
