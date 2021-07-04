//
//  OTMTabViewcontroller.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation
import UIKit

class OTMTabViewcontroller: UITabBarController {
    
    @IBAction func postInformationActionButton(_ sender: Any) {
        print("test")
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.logout() {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
