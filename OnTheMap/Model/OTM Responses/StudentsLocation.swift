//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

struct StudentsLocation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}


