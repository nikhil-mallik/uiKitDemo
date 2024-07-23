//
//  FilterFoodListViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 23/07/24.
//

import UIKit

class FilterFoodListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    @IBOutlet weak var filterBtn: UIButton!
    
    // MARK: - Variable
    private let manager =  FoodDatabaseManager()
    var selectedCategoryName = ""
    var selectedCategoryId = ""
    var selectedCategory: CategoryEntity?
    var categoryFood: [CategoryEntity] =  []
    weak var delegate: FilterFoodDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryFood = manager.fetchCategory()
        categoryTableView.isHidden = true
        categoryTableView.reloadData()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dropdownBtn.setTitle("", for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func dropdownBtnAction(_ sender: Any) {
        toggleDropdown()
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        let startDate: Date = fromDate.date
        let endDate: Date = toDate.date
        let categoryName: CategoryEntity? = selectedCategory
        
        // Validate date range
        if endDate < startDate {
            AlertHelper.showAlert(withTitle: "Invalid Date Range", message: "The `To Date` cannot be earlier than the start date.", from: self)
            return
        }
        
        // Apply filter
        delegate?.didApplyFilter(startDate: startDate, endDate: endDate, category: categoryName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFilterAction(_ sender: UIButton) {
        delegate?.didClearFilter()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension for shared instance
extension FilterFoodListViewController {
    static func sharedInstance() -> FilterFoodListViewController {
        return FilterFoodListViewController.instantiateFromStoryboard("FilterFoodListViewController")
    }
}

// MARK: - UITableViewDataSource
extension FilterFoodListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(categoryFood.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < categoryFood.count {
            cell.textLabel?.text = categoryFood[indexPath.row].catName
        } else {
            cell.textLabel?.text = "Category not available"
        }
        cell.backgroundColor = .systemGray5
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterFoodListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < categoryFood.count else { return }
        selectedCategoryName = categoryFood[indexPath.row].catName!
        selectedCategoryId = categoryFood[indexPath.row].catId!
        categoryLabel.text = selectedCategoryName
        selectedCategory = categoryFood[indexPath.row]
        if !tableView.isHidden {
            toggleDropdown()
        }
    }
    
    // MARK: - Dropdown Toggle
    func toggleDropdown() {
        categoryTableView.isHidden.toggle()
        if !categoryTableView.isHidden {
            adjustTableViewHeight()
        } else {
            collapseTableView()
        }
    }
    
    // MARK: - Adjust TableView Height
    private func adjustTableViewHeight() {
        categoryTableView.translatesAutoresizingMaskIntoConstraints = true
        let maxHeight = CGFloat(categoryFood.count * 44) + 60
        let adjustedHeight = min(maxHeight, 380)
        categoryTableView.frame.size.height = adjustedHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Collapse TableView
    private func collapseTableView() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTableView.frame.size.height = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.categoryTableView.isHidden = true
        }
    }
}
