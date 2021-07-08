//
//  UserRequest.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 04/07/2021.
//

import Foundation

struct User: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mediaURL: String?
    let objectId: String?
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey = "key"
        case firstName = "first_name"
        case lastName = "last_name"
        case mediaURL = "website_url"
        case objectId
    }
}
