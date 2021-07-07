//
//  AddStudentLocation.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 07/07/2021.
//

import Foundation

struct AddStudentLocation: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName:  String
    var mapString: String
    var mediaURL:  String
    var latitude:  Float
    var longitude: Float
}
