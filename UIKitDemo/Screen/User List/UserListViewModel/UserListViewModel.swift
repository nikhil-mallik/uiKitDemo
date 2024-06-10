//
//  UserListViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import UIKit

// MARK: - UserListViewModel Class
class UserListViewModel {
    // Array to hold user data
    var arrUsers: [UserListModel] = []
    // Closure to handle events from the view model
    var eventHandler: ((_ event: Event) -> Void)?
    
    // Method to fetch all user data from the API
    func getAllUserData() {
        // Make a network request to fetch user data
        APIManager.shared.request(requestModel: nil, responseModelType: [UserListModel].self, type: APIEndPoint.users) { result in
            switch result {
            case .success(let userResponse):
                // Update array with fetched user data
                self.arrUsers = userResponse
                // Notify the event handler that data has been loaded
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                // Notify the event handler about the error
                self.eventHandler?(.error(error))
                print(error.localizedDescription) 
            }
        }
    }
}

