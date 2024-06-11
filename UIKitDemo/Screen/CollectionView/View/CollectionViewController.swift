//
//  CollectionViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 11/06/24.
//

import UIKit

class CollectionViewController: UIViewController {
    

   
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    // MARK: - Variables
    private var viewModel = productListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    func configuration() {
//        collectionViewOutlet.dataSource = self
//        collectionViewOutlet.delegate = self
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
                    self.collectionViewOutlet.reloadData()
                }
            case .error(let error):
                print(error as Any)
            case .dataPassed:
                print("Data passed...")
            }
        }
    }
}

extension CollectionViewController {
    
    static func sharedIntance() -> CollectionViewController {
        return CollectionViewController.instantiateFromStoryboard("CollectionViewController")
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = viewModel.products[indexPath.row]
        showProductDetail(for: selectedProduct)
        
        // Function to show product details
        func showProductDetail(for product: ProductListModel) {
            print("showProductDetail")
            let productDetailVC = ProductDetailsViewController.sharedIntance()
            productDetailVC.product = product
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20) / 2
        
        return CGSize(width: size, height: size)
    }
}
