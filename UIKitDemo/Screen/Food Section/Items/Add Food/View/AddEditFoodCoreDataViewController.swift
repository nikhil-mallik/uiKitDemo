//
//  AddEditFoodCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class AddEditFoodCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryDropdownBtn: UIButton!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var categoryTblView: UITableView!
    @IBOutlet weak var itemTxtFd: UITextField!
    @IBOutlet weak var purchaseDate: UIDatePicker!
    @IBOutlet weak var expireDate: UIDatePicker!
    @IBOutlet weak var priceTxtFd: UITextField!
    @IBOutlet weak var quantityTxtFd: UITextField!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var setNotificationTime: UIDatePicker!
    
    
    // MARK: - Variable
    private let manager =  FoodDatabaseManager()
    var selectedCategoryName = ""
    var selectedCategoryId = ""
    var items: FoodEntity?
    var categoryFood: [CategoryEntity] =  []
    var selectedNotificationTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTextFields()
        itemsDetailConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryFood = manager.fetchCategory()
        categoryTblView.isHidden = true
        categoryTblView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        saveBtn.setTitle(items != nil ? "Update" : "Save", for: .normal)
        navigationItem.title = items != nil ? "Update Item" : "Add Item"
        categoryDropdownBtn.setTitle("", for: .normal)
    }
    
    private func setupTableView() {
        categoryTblView.dataSource = self
        categoryTblView.delegate = self
        categoryTblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupTextFields() {
        priceTxtFd.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        quantityTxtFd.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    @IBAction func settingNotificationTime(_ sender: Any) {
        selectedNotificationTime = setNotificationTime.date
    }
    
    
    
    @IBAction func categoryDropdownBtnAction(_ sender: Any) {
        toggleDropdown()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        saveItems()
    }
}

extension AddEditFoodCoreDataViewController {
    // MARK: - Helper Methods
    private func showAlert(message: String) {
        AlertHelper.showAlert(withTitle: "Alert", message: message, from: self)
    }
    
    private func calculateTotal(price: Float, quantity: Float) -> String {
        return String(format: "%.2f", price * quantity)
    }
    private func updateTotalPrice() {
        guard let priceText = priceTxtFd.text, let quantityText = quantityTxtFd.text,
              let price = Float(priceText), let quantity = Float(quantityText) else {
            return
        }
        totalPriceLbl.text = calculateTotal(price: price, quantity: quantity)
    }
    // MARK: - Data Handling
    func itemsDetailConfiguration() {
        if let items = items {
            selectedCategoryId = items.categoryId!
            selectedCategoryName = items.categoryName!
            categoryNameLbl.text = items.categoryName
            itemTxtFd.text = items.itemName
            purchaseDate.date = items.purchaseDate ?? Date()
            expireDate.date = items.expireDate ?? Date()
            setNotificationTime.date = items.notificationTime ?? Date()
            priceTxtFd.text = "\(items.priceAmt)"
            quantityTxtFd.text = "\(items.quantities)"
            totalPriceLbl.text = "\(items.totalPrice)"
        }
    }
    
    // Validates and saves the items.
    func saveItems() {
        guard !selectedCategoryName.isEmpty && !selectedCategoryId.isEmpty else {
            showAlert(message: "Please Select Category")
            return
        }
        guard let itemName = itemTxtFd.text, !itemName.isEmpty else {
            showAlert(message: "Please enter Item name")
            return
        }
        guard let priceText = priceTxtFd.text, let price = Float(priceText), price > 0 else {
            showAlert(message: "Please enter a valid price greater than 0")
            return
        }
        guard let quantityText = quantityTxtFd.text, let quantity = Float(quantityText), quantity > 0 else {
            showAlert(message: "Please enter a valid quantity greater than 0")
            return
        }
        
   
        let purchasesDate = purchaseDate.date
        let expireDate = expireDate.date
        let notificationTime = setNotificationTime.date

        // Validate that expire date is not earlier than purchase date
        guard expireDate >= purchasesDate else {
            showAlert(message: "Expire date cannot be earlier than purchase date")
            return
        }
        let formattedTotalCount = calculateTotal(price: price, quantity: quantity)
        
        let newItem = FoodModel(categoryId: selectedCategoryId,
                                categoryName: selectedCategoryName,
                                expireDate: expireDate,
                                purchaseDate: purchasesDate,
                                itemName: itemName,
                                priceAmt: price,
                                quantity: Int64(quantity),
                                totalPrice: Float(formattedTotalCount)!, 
                                notificationTime: notificationTime)
        
        if let items = items {
            manager.updateItems(food: newItem, foodEntity: items)
        } else {
            manager.addItems(newItem)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddEditFoodCoreDataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(categoryFood.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < categoryFood.count {
            cell.textLabel?.text = categoryFood[indexPath.row].categoryName
        } else {
            cell.textLabel?.text = "Category not available"
        }
        cell.backgroundColor = .systemGray5
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddEditFoodCoreDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < categoryFood.count else { return }
        selectedCategoryName = categoryFood[indexPath.row].categoryName!
        selectedCategoryId = categoryFood[indexPath.row].categoryId!
        categoryNameLbl.text = selectedCategoryName
        if !tableView.isHidden {
            toggleDropdown()
        }
    }
    
    func toggleDropdown() {
        categoryTblView.isHidden.toggle()
        if !categoryTblView.isHidden {
            adjustTableViewHeight()
        } else {
            collapseTableView()
        }
    }
    
    private func adjustTableViewHeight() {
        categoryTblView.translatesAutoresizingMaskIntoConstraints = true
        let maxHeight = CGFloat(categoryFood.count * 44) + 60
        let adjustedHeight = min(maxHeight, 480)
        categoryTblView.frame.size.height = adjustedHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func collapseTableView() {
        UIView.animate(withDuration: 0.3) {
            self.categoryTblView.frame.size.height = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.categoryTblView.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddEditFoodCoreDataViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateTotalPrice()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTotalPrice()
    }
}

// MARK: - Shared Instance Extension
extension AddEditFoodCoreDataViewController {
    static func sharedInstance() -> AddEditFoodCoreDataViewController {
        return AddEditFoodCoreDataViewController.instantiateFromStoryboard("AddEditFoodCoreDataViewController")
    }
}
