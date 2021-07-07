//
//  OTMTabViewcontroller.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation
import UIKit

class OTMTabViewcontroller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("******* TAB VIEW CONTROLLER *******")
        print(OTMClient.UserData.self)
        print(OTMClient.UserData.objectId)
        print("******* END TAB VIEW CONTROLLER *******")
        
    }
    
    @IBAction func postInformationActionButton(_ sender: Any) {
        
        if (OTMClient.UserData.objectId == "") {
            presentPostInformationVC()
        } else {
            showAlert(message: "You Have Already Posted a Student Location, Whould You Like To Overwrite Your Current Location?")
        }
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.logout() {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
            self.presentPostInformationVC()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    func presentPostInformationVC() {
        let postInformationVC = storyboard?.instantiateViewController(withIdentifier: "PostInformationVC") as! UINavigationController
        postInformationVC.modalPresentationStyle = .fullScreen
        
        present(postInformationVC, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        print("calling")
        StudentsLocationTableViewController().refreshData()
    }
    
}
