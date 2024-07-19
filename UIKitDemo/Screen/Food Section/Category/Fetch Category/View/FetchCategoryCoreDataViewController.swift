//
//  FetchCategoryCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class FetchCategoryCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var navBarBtn: UIBarButtonItem!
    
    // MARK: - Variable
    private var categories: [CategoryEntity] = []
    private let manager = FoodDatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.register(UINib(nibName: "FoodCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodCategoryTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategoriesAndUpdateTable()
    }
    
    @IBAction func navBarBtnAction(_ sender: UIButton) {
        addUpdateCategoryNavigation()
    }
    
    // MARK: - Data Handling
    private func fetchCategoriesAndUpdateTable() {
        categories = manager.fetchCategory()
        categoryTableView.reloadData()
    }
    // MARK: - Navigation Methods
    func addUpdateCategoryNavigation(category: CategoryEntity? = nil) {
        let addEditVC = AddEditCategoryCoreDataViewController.sharedInstance()
        addEditVC.category = category
        addEditVC.delegate = self
        configurePopoverPresentation(for: addEditVC)
        present(addEditVC, animated: true, completion: nil)
    }
    
    // MARK: - Popover Presentation Configuration
    private func configurePopoverPresentation(for viewController: UIViewController) {
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 300, height: 200)
        
        if let popoverPresentationController = viewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = navBarBtn
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = self
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension FetchCategoryCoreDataViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Extension for shared instance
extension FetchCategoryCoreDataViewController {
    static func sharedInstance() -> FetchCategoryCoreDataViewController {
        return FetchCategoryCoreDataViewController.instantiateFromStoryboard("FetchCategoryCoreDataViewController")
    }
}

// MARK: - UITableViewDataSource
extension FetchCategoryCoreDataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryTableViewCell") as? FoodCategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        cell.category = category
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FetchCategoryCoreDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateCategoryNavigation(category: self.categories[indexPath.row])
        }
        update.backgroundColor = .systemIndigo
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteCategory(categoryEntity: self.categories[indexPath.row])// Core Data
            self.categories.remove(at: indexPath.row) // Array
            self.categoryTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

// MARK: - AddEditCategoryDelegate
extension FetchCategoryCoreDataViewController: AddEditCategoryDelegate {
    func didSaveCategory() {
        categories = manager.fetchCategory()
        categoryTableView.reloadData()
    }
}

protocol AddEditCategoryDelegate: AnyObject {
    func didSaveCategory()
}
