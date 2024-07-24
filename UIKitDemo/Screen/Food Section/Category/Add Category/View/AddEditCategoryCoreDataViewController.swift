//
//  AddEditCategoryCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class AddEditCategoryCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryTxtFd: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: - Variable
    var category: CategoryEntity?
    private let manager =  FoodDatabaseManager()
    weak var delegate: AddEditCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetailConfiguration()
    }
    
    // MARK: - Actions
    @IBAction func saveBtnAction(_ sender: Any) {
        saveCategory()
    }
    
    // MARK: - Configuration Methods
    func categoryDetailConfiguration() {
        if let category {
            saveBtn.setTitle("Update", for: .normal)
            navigationItem.title = "Update Category"
            categoryTxtFd.text = category.categoryName
        } else {
            navigationItem.title = "Add Category"
            saveBtn.setTitle("Save", for: .normal)
        }
    }
    
    // Validates and saves the Category.
    func saveCategory() {
        guard let CategoryName = categoryTxtFd.text, !CategoryName.isEmpty else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Please enter category name", from: self)
            return
        }
        let created = Date()
        
        if let category {
            let newCategory = CategoryModel(categoryId: category.categoryId!, categoryName: CategoryName, createdAt: created)
            manager.updateCategory(category: newCategory, categoryEntity: category)
        } else {
            let id = UUID().uuidString
            let newCategory = CategoryModel(categoryId: id, categoryName: CategoryName, createdAt: created)
            manager.addCategory(newCategory)
        }
        delegate?.didSaveCategory()
        // Dismiss the popover
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension for shared instance
extension AddEditCategoryCoreDataViewController {
    static func sharedInstance() -> AddEditCategoryCoreDataViewController {
        return AddEditCategoryCoreDataViewController.instantiateFromStoryboard("AddEditCategoryCoreDataViewController")
    }
}
