//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

struct StudentsLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let objectId: String
    let createdAt: String
    let updatedAt: String
}


