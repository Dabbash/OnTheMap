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
    
    @IBOutlet weak var mapView: MKMapView!
    
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    
    public var mapString: String = ""
    public var mediaURL: String = ""
    
    @IBOutlet weak var finishButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        finishButton.layer.cornerRadius = 3
        
        print(mapString)
        searchLocation()
    }
    
    func searchLocation() {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = self.mapString
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                self.showAlert(message: "We couldn't find this location, please type a correct location")
                return
            }
            
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
                
            let latitude = response.boundingRegion.center.latitude
            let longitude = response.boundingRegion.center.longitude
            
            self.latitude = latitude
            self.longitude = longitude
                
            var annotation = MKPointAnnotation()
            annotation.title = self.mapString
            annotation.subtitle = self.mediaURL
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.addAnnotation(annotation)
            
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
        }
    }
        
    /*
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
    */

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.shared
            app.openURL(NSURL(string: annotationView.annotation?.subtitle! ?? "") as! URL)
        }
    }
    
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { action in
                                        _ = self.navigationController?.popViewController(animated: true)

                                      }))

        self.present(alert, animated: true)
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        setSendingLocation(true)
        OTMClient.postStudentLocation(mapString: self.mapString,
                                      mediaURL: self.mediaURL,
                                      latitude: self.latitude,
                                      longitude: self.longitude,
                                      completion: self.handleAddLocationResponse(success:error:))
    }
    
    func handleAddLocationResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            setSendingLocation(false)
            showAlert(message: error?.localizedDescription ?? "")
        }
  
    }

    func setSendingLocation(_ sendingLocation: Bool) {
        if sendingLocation {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        finishButton.isEnabled = !sendingLocation
    }
 
}

