//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: UdacityLoginRequest
}

struct UdacityLoginRequest: Codable {
    let username: String
    let password: String
}

