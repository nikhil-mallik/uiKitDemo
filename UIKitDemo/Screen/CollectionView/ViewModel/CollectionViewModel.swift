//
//  CollectionViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 11/06/24.
//

import Foundation

final class CollectionViewModel {
    // Array to hold products
    var products: [ProductListModel] = []
    // Data Binding Closure
    var eventHandler: ((_ event: Event) -> Void)?

    // Method to fetch products
    func fetchProducts() {
        
        // Notify event handler that data loading started
        self.eventHandler?(.loading)
        
        // Make a network request to fetch products
        APIManager.shared.request(requestModel: nil, responseModelType: [ProductListModel].self, type: APIEndPoint.products) { response in
            
            // Notify event handler
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                // Update products array with fetched products
                self.products = products
                self.eventHandler?(.dataLoaded) // Notify event handler
            case .failure(let error):
                // Notify event handler
                self.eventHandler?(.error(error))
            }
        }
    }
}

