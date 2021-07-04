//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

struct OTMResponse: Codable {
    let account: account
}

struct account: Codable {
    let registered: Bool
    let key: String
}
