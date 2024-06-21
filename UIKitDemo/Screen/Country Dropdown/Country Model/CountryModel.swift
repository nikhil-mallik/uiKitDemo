//
//  CountryModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import Foundation

import Foundation

// Models for the JSON response
struct Country: Codable {
    let name: String
    let Iso2: String
    let Iso3: String
}

struct Statess: Codable {
    let name: String
    let stateCode: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case stateCode = "state_code"
    }
}

struct City: Codable {
    let name: String
}

struct CountriesResponse: Codable {
    let error: Bool
    let msg: String
    let data: [Country]
}

struct StatesResponse: Codable {
    let error: Bool
    let msg: String
    let data: StateData
    
    struct StateData: Codable {
        let name: String
        let iso3: String
        let iso2: String
        let states: [Statess]
    }
}

struct CitiesResponse: Codable {
    let error: Bool
    let msg: String
    let data: [String]
}

let defaultStatesValue = Statess(name: "No State", stateCode: "000")
