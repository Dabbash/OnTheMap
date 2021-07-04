//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

struct SessionResponse: Codable {
    let session: Session
    let account: Account
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
