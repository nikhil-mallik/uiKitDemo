//
//  StickyHeaderViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 03/07/24.
//

import Foundation

final class StickyHeaderViewModel {
    // Array to hold sectioned products
    var sectionedProducts: [ProductSection] = []
    var products: [ProductListModel] = []
    
    // Data Binding Closure
    var eventHandler: ((_ event: Event) -> Void)?
    
    // Method to fetch products
    func fetchProducts() {
        
        // Notify event handler that data loading started
        self.eventHandler?(.loading)
        
        // Make a network request to fetch products
        APIManager.shared.request(requestModel: nil, responseModelType: [ProductListModel].self, type: APIEndPoint.products) { response in
            print("API Hit")
            // Notify event handler
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                // Update products array with fetched products
                let updatedProducts = products.map { product in
                    var updatedLikeProduct = product
                    updatedLikeProduct.isLiked = false
                    return updatedLikeProduct
                }
                self.products = updatedProducts
                // Update sectionedProducts array with fetched products grouped by category
                let groupedProducts = Dictionary(grouping: updatedProducts) { $0.category }
                self.sectionedProducts = groupedProducts.map { ProductSection(category: $0.key, products: $0.value) }
                self.eventHandler?(.dataLoaded) // Notify event handler
            case .failure(let error):
                // Notify event handler
                self.eventHandler?(.error(error))
            }
        }
    }
    
    // Fetch product details for the previous product
    func fetchPreviousProduct(currentSection: Int, currentProductIndex: Int) -> ProductListModel? {
        guard currentSection >= 0, currentProductIndex > 0 else {
            return nil
        }
        return sectionedProducts[currentSection].products[currentProductIndex - 1]
    }
    
    // Fetch product details for the next product
    func fetchNextProduct(currentSection: Int, currentProductIndex: Int) -> ProductListModel? {
        guard currentSection >= 0, currentProductIndex < sectionedProducts[currentSection].products.count - 1 else {
            return nil
        }
        return sectionedProducts[currentSection].products[currentProductIndex + 1]
    }
}
