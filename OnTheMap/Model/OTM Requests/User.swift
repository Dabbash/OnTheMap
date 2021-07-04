//
//  UserRequest.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 04/07/2021.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
