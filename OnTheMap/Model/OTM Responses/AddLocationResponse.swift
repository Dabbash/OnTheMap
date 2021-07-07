//
//  AddLocationResponse.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 07/07/2021.
//

import Foundation

struct AddLocationResponse: Codable {
    let objectId: String
    let createdAt: String
}

struct AddLocationResponse1: Codable {
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}
