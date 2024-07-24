//
//  FoodCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class FetchFoodCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var foodListTableView: UITableView!
    @IBOutlet weak var navBarCategoryBtn: UIBarButtonItem!
    @IBOutlet weak var navBarItemBtn: UIBarButtonItem!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: - Variables
    private var foodItems: [FoodEntity] = []
    private let manager = FoodDatabaseManager()
    private var groupedFoodItems: [String: [FoodEntity]] = [:]
    private var sortedCategoryNames: [String] = []
    private var expandedSections: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndUpdateFoodItems()
    }
    
    // MARK: - Action Methods
    @IBAction func navBarCategoryBtnAction(_ sender: Any) {
        let categoryVC = FetchCategoryCoreDataViewController.sharedInstance()
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func navBarItemBtnAction(_ sender: Any) {
        addUpdateUserNavigation()
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        let filterVC = FilterFoodListViewController.sharedInstance()
        filterVC.delegate = self
        configurePopoverPresentation(for: filterVC)
        present(filterVC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation Methods
    func addUpdateUserNavigation(items: FoodEntity? = nil) {
        let addCoreDataVC = AddEditFoodCoreDataViewController.sharedInstance()
        addCoreDataVC.items = items
        self.navigationController?.pushViewController(addCoreDataVC, animated: true)
    }
    
    // MARK: - Popover Presentation Configuration
    private func configurePopoverPresentation(for viewController: UIViewController) {
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 300, height:500)
        
        if let popoverPresentationController = viewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = filterBtn
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = self
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension FetchFoodCoreDataViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: Extension for Helper Methods
extension FetchFoodCoreDataViewController {
    
    // MARK: - Setup TableView
    private func setupTableView() {
        foodListTableView.register(UINib(nibName: "FoodItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodItemsTableViewCell")
        foodListTableView.register(UINib(nibName: "StickHeaderFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "StickHeaderFooter")
    }
    
    // MARK: - Data Handling
    private func fetchAndUpdateFoodItems() {
        foodItems = manager.fetchFood()
        groupFoodItemsByCategory()
        foodListTableView.reloadData()
        noDataLabel.alpha = 0
        foodListTableView.isHidden = false
    }
    
    private func groupFoodItemsByCategory() {
        // Sort foodItems by expireDate
        foodItems.sort { ($0.expireDate ?? Date.distantFuture) < ($1.expireDate ?? Date.distantFuture) }
        groupedFoodItems.removeAll()
        for item in foodItems {
            let categoryName = item.categoryName ?? "Uncategorized"
            if groupedFoodItems[categoryName] != nil {
                groupedFoodItems[categoryName]?.append(item)
            } else {
                groupedFoodItems[categoryName] = [item]
            }
        }
        sortedCategoryNames = groupedFoodItems.keys.sorted()
    }
    
    // MARK: - Handle Actions
    private func handleUpdateAction(forRowAt indexPath: IndexPath) {
        let categoryName = sortedCategoryNames[indexPath.section]
        if let foodItems = groupedFoodItems[categoryName] {
            addUpdateUserNavigation(items: foodItems[indexPath.row])
        }
    }
    
    private func handleDeleteAction(forRowAt indexPath: IndexPath) {
        let categoryName = sortedCategoryNames[indexPath.section]
        if let foodItems = groupedFoodItems[categoryName] {
            manager.deleteFood(foodEntity: foodItems[indexPath.row]) // Delete from Core Data
            self.foodItems.removeAll { $0 == foodItems[indexPath.row] } // Remove from array
            groupFoodItemsByCategory()
            foodListTableView.reloadData()
        }
    }
    
    // MARK: - Header Tap Handling
    @objc private func handleHeaderTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let headerView = gestureRecognizer.view as? StickHeaderFooter else { return }
        let section = headerView.tag
        
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        // Reload the affected section to show/hide rows
        foodListTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - Filtering
    private func filterFoodItems(startDate: Date, endDate: Date, categoryName: CategoryEntity?) {
        let filteredItems = foodItems.filter { item in
            guard let expiryDate = item.expireDate else { return false }
            let isInDateRange = (expiryDate >= startDate && expiryDate <= endDate)
            if let category = categoryName {
                return isInDateRange && item.categoryName == category.categoryName
            } else {
                return isInDateRange
            }
        }
        
        // Update the grouped items and reload the table view
        groupedFoodItems.removeAll()
        for item in filteredItems {
            let categoryName = item.categoryName ?? "Uncategorized"
            if groupedFoodItems[categoryName] != nil {
                groupedFoodItems[categoryName]?.append(item)
            } else {
                groupedFoodItems[categoryName] = [item]
            }
        }
        sortedCategoryNames = groupedFoodItems.keys.sorted()
        if filteredItems.isEmpty {
            noDataLabel.alpha = 1
            foodListTableView.isHidden = true
        } else {
            noDataLabel.alpha = 0
            foodListTableView.isHidden = false
            foodListTableView.reloadData()
        }
    }
}

// MARK: - Extension for shared instance
extension FetchFoodCoreDataViewController {
    static func sharedInstance() -> FetchFoodCoreDataViewController {
        return FetchFoodCoreDataViewController.instantiateFromStoryboard("FetchFoodCoreDataViewController")
    }
}

// MARK: - UITableViewDelegate
extension FetchFoodCoreDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Update") { [weak self] _, _, completionHandler in
            self?.handleUpdateAction(forRowAt: indexPath)
            completionHandler(true)
        }
        updateAction.backgroundColor = .systemIndigo
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let categoryName = self.sortedCategoryNames[indexPath.section]
            if let foodItem = self.groupedFoodItems[categoryName]?[indexPath.row] {
                let itemName = foodItem.itemName ?? "this item"
                AlertHelper.showConfirmationAlert(title: "Confirm Action", message: "Are you sure you want to delete \(itemName)?", in: self, confirmAction: {
                    self.handleDeleteAction(forRowAt: indexPath)
                    completionHandler(true)
                }, cancelAction: {
                    completionHandler(false)
                })
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - UITableViewDataSource
extension FetchFoodCoreDataViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCategoryNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryName = sortedCategoryNames[section]
        if expandedSections.contains(section) {
            return groupedFoodItems[categoryName]?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsTableViewCell", for: indexPath) as? FoodItemsTableViewCell else {
            return UITableViewCell()
        }
        let categoryName = sortedCategoryNames[indexPath.section]
        if let foodItems = groupedFoodItems[categoryName] {
            cell.foodItem = foodItems[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        
        // Reload the affected section to show/hide rows
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StickHeaderFooter") as? StickHeaderFooter else {
            return nil
        }
        headerView.headerTitleLabel.text = sortedCategoryNames[section]
        // Determine the correct image based on the expanded/collapsed state
        let isExpanded = expandedSections.contains(section)
        let imageName = isExpanded ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
        headerView.headerImageView.image = UIImage(systemName: imageName)
        
        // Add tap gesture recognizer to the header view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section  // Set the section tag
        return headerView
    }
}

// MARK: - AddEditFoodCoreDataViewControllerDelegate
extension FetchFoodCoreDataViewController: FilterFoodDataDelegate {
    
    //MARK: - Clear Filter
    func didClearFilter() {
        fetchAndUpdateFoodItems()
    }
    
    // MARK: - Apply Filter
    func didApplyFilter(startDate: Date, endDate: Date, category: CategoryEntity?) {
        filterFoodItems(startDate: startDate, endDate: endDate, categoryName: category)
    }
}

protocol FilterFoodDataDelegate: AnyObject {
    func didApplyFilter(startDate: Date, endDate: Date, category: CategoryEntity?)
    func didClearFilter()
}

