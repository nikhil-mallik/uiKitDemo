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
        return cell
    }

}
