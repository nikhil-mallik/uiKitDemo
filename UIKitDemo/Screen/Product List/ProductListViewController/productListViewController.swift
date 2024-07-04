//
//  productListViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import UIKit

class ProductListViewController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var productTableView: UITableView!
    
    // MARK: - Variables
    private var viewModel = productListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

}

extension ProductListViewController {

    // Method for initial configuration
    func configuration() {
        // Register custom cell nib for table view
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        productTableView.delegate = self
        productTableView.dataSource = self
        initViewModel()
        observeEvent()
    }

    // Method to initialize the view model
    func initViewModel() {
        viewModel.fetchProducts()
    }

    // Method to observe events from the view model
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                /// Indicator show
                print("Product loading....")
            case .stopLoading:
                // Indicator hide kardo
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // UI Main works well
                    self.productTableView.reloadData()
                }
            case .error(let error):
                print(error as Any)
            case .dataPassed:
                print("Data passed...")
            }
        }
    }

}

// Extension for shared instance creation
extension ProductListViewController {
    static func sharedIntance() -> ProductListViewController {
        return ProductListViewController.instantiateFromStoryboard("ProductListViewController")
    }
}

// Extension conforming to UITableViewDataSource protocol
extension ProductListViewController: UITableViewDataSource {

    // Method to return number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }

    // Method to configure and return a cell for a given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }
        
        // Set product data for the cell
        let product = viewModel.products[indexPath.row]
        cell.product = product
        cell.delegate = self
        return cell
    }
}

// Extension conforming to UITableViewDelegate protocol
extension ProductListViewController: UITableViewDelegate {
    
    // Called when a table view row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.products[indexPath.row]
        showProductDetail(for: selectedProduct, at: indexPath.row)
    }
    
    // Function to show product details
    func showProductDetail(for product: ProductListModel, at index: Int) {
        print("showProductDetail")
        let productDetailVC = ProductDetailsView.sharedIntance()
        productDetailVC.product = product
        productDetailVC.currentIndex = index
        productDetailVC.viewModel.products = viewModel.products
        productDetailVC.productDelegate = self
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension ProductListViewController: ProductDetailsDelegate {
    // Delegate method to update product
    func didUpdateProduct(_ product: ProductListModel, at index: Int) {
        viewModel.products[index] = product
        productTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension ProductListViewController: ProductCellDelegate {
    func didToggleLikeUnlike(for product: ProductListModel) {
        guard let index = viewModel.products.firstIndex(where: { $0.id == product.id }) else {
            return
        }
        // Toggle the isLiked property of the product
        viewModel.products[index].isLiked!.toggle()

        // Update the product in the view model
        let updatedProduct = viewModel.products[index]
        
        DispatchQueue.main.async {
            self.productTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

