//
//  Constant.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import Foundation

// MARK: - API Keys
let app_id = "080A71B8-59FA-4150-B05F-2736DC331E96" // Application ID for the API
let rest_key = "712DE557-225D-4481-AFA5-2186915518FE" // REST key for the API
let google_api_Key = "AIzaSyA3oG1i0JuVGSIWJ76kusSBzK9NcD_5EBk"
// MARK: - API for Country
let baseUrl = "https://countriesnow.space/api/v0.1/countries/"
let countryAPI = "\(baseUrl)iso"
let stateAPI = "\(baseUrl)states"
let cityAPI = "\(baseUrl)state/cities"
// MARK: - TokenKey
struct TokenKey {
    
    // Key for storing user login information
    static let userLogin = "USER_LOGIN_KEY"
    
    // Key for storing user name information
    static let userName = "USER_NAME_KEY"
}

struct isLikedValue {
    
    // Key for storing product Like information
    static let isLikedProduct = "isLiked"
}

