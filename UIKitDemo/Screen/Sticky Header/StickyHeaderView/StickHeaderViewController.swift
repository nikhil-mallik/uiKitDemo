//
//  StickHeaderViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 03/07/24.
//

import UIKit

class StickHeaderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = StickyHeaderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    // Method for initial configuration
    func configuration() {
        initViewModel()
        tableView.register(UINib(nibName: "StickHeaderFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "StickHeaderFooter")
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        // Remove top space above the image view
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
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
                LoaderViewHelper.showLoaderView(on: self.view )
            case .stopLoading:
                LoaderViewHelper.hideLoader()
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // UI Main works well
                    self.tableView.reloadData()
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
extension StickHeaderViewController {
    static func sharedIntance() -> StickHeaderViewController {
        return StickHeaderViewController.instantiateFromStoryboard("StickHeaderViewController")
    }
}

extension StickHeaderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    // Set the height for the header in section 0 to 0
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    // Called when a table view row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.sectionedProducts[indexPath.section - 1].products[indexPath.row]
        showProductDetail(for: selectedProduct, at: indexPath.row, in: indexPath.section)
    }
    func showProductDetail(for product: ProductListModel, at index: Int, in section: Int) {
        let productDetailVC = ProductDetailsView.sharedIntance()
        productDetailVC.product = product
        productDetailVC.currentIndex = index
        productDetailVC.viewModel.products = viewModel.products
        productDetailVC.productDelegate = self  // Set the new delegate
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension StickHeaderViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionedProducts.count + 1
    }
    
    // Method to return number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.sectionedProducts[section - 1].products.count
        }
    }
    
    // Method to configure and return a cell for a given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.products = viewModel.sectionedProducts.flatMap { $0.products }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
                return UITableViewCell()
            }
            
            // Set product data for the cell
            let product = viewModel.sectionedProducts[indexPath.section - 1 ].products[indexPath.row]
            cell.product = product
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return  nil  // No header for the image section
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StickHeaderFooter") as? StickHeaderFooter
            headerView?.headerTitleLabel.text = viewModel.sectionedProducts[section - 1].category
            return headerView
        }
    }
}

// Implement the ProductDetailsDelegate in StickHeaderViewController
extension StickHeaderViewController: ProductDetailsDelegate {
    
    func didUpdateProduct(_ product: ProductListModel, at index: Int) {
        if let sectionIndex = viewModel.sectionedProducts.firstIndex(where: { $0.category == product.category }) {
            if let productIndex = viewModel.sectionedProducts[sectionIndex].products.firstIndex(where: { $0.id == product.id }) {
                viewModel.sectionedProducts[sectionIndex].products[productIndex] = product
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension StickHeaderViewController: ProductCellDelegate {
    func didToggleLikeUnlike(for product: ProductListModel) {
        guard let sectionIndex = viewModel.sectionedProducts.firstIndex(where: { $0.category == product.category }),
              let productIndex = viewModel.sectionedProducts[sectionIndex].products.firstIndex(where: { $0.id == product.id }) else {
            return
        }
        // Update product in view model
        viewModel.sectionedProducts[sectionIndex].products[productIndex] = product
        // Update specific row in table view
        let indexPath = IndexPath(row: productIndex, section: sectionIndex + 1) // Adjust section index for header
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
