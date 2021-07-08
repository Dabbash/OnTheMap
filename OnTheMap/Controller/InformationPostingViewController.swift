//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var linkedinTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //OTMClient.LocationDetails.firstName = "Noon"
        //OTMClient.LocationDetails.lastName = "Moon"
        UserData.mapString = locationNameTextField.text!
        UserData.mediaURL = linkedinTextField.text!
        
    }
    
    
    @IBAction func findLocationButtonAction(_ sender: Any) {
        if (locationNameTextField.text == "" || linkedinTextField.text == "") {
            showFailure(message: "You need to fill all the fields")
        } else {
            performSegue(withIdentifier: "findLocation", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addLocationVC = segue.destination as! AddLocationViewController
        addLocationVC.mapString = locationNameTextField.text!
        addLocationVC.mediaURL = linkedinTextField.text!
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss (animated: true, completion: nil)
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
