//
//  DatabaseManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit
import CoreData

class FoodDatabaseManager {
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: Add Category
    func addCategory(_ category: CategoryModel) {
        let categoryEntity = CategoryEntity(context: context)
        addUpdateCategory(categoryEntity: categoryEntity, category: category)
    }
    
    // MARK: Update Category
    func updateCategory(category: CategoryModel, categoryEntity: CategoryEntity) {
        addUpdateCategory(categoryEntity: categoryEntity, category: category)
    }
    
    
    private func addUpdateCategory(categoryEntity: CategoryEntity, category: CategoryModel) {
        categoryEntity.catId = category.catId
        categoryEntity.catName = category.catName
        saveContext()
    }
    
    // MARK: Fetch Category
    func fetchCategory() -> [CategoryEntity] {
        var category: [CategoryEntity] = []
        
        do {
            category = try context.fetch(CategoryEntity.fetchRequest())
        }catch {
            print("Fetch category error", error)
        }
        return category
    }
    
    // MARK: Add Food item
    func addItems(_ food: FoodModel) {
        let foodEntity = FoodEntity(context: context)
        addUpdateFoodItem(foodEntity: foodEntity, food: food)
    }
    
    // MARK: Update Food item
    func updateItems(food: FoodModel, foodEntity: FoodEntity) {
        addUpdateFoodItem(foodEntity: foodEntity, food: food)
    }
    
    private func addUpdateFoodItem(foodEntity: FoodEntity, food: FoodModel) {
        foodEntity.catId = food.catId
        foodEntity.categoryName = food.catName
        foodEntity.expireDate = food.expireDate
        foodEntity.itemName = food.itemName
        foodEntity.priceAmt = food.priceAmt
        foodEntity.purchaseDate = food.purchaseDate
        foodEntity.quantities = food.quantity
        foodEntity.totalPrice = food.totalPrice
        saveContext()
    } 
    
    // MARK: Fetch Food item
    func fetchFood() -> [FoodEntity] {
        var foodItems: [FoodEntity] = []
        
        do {
            foodItems = try context.fetch(FoodEntity.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }
        return foodItems
    }
    
    // MARK: Save Context
    func saveContext() {
        do {
            try context.save()
        }catch {
            print("User saving error:", error)
        }
        printDatabasePath()
    }
    
    // MARK: Delete Food item
    func deleteFood(foodEntity: FoodEntity) {
        context.delete(foodEntity)
        saveContext()
    }
    // MARK: Delete Category
    func deleteCategory(categoryEntity: CategoryEntity) {
        context.delete(categoryEntity)
        saveContext()
    }
    
    func printDatabasePath() {
        if let storeURL = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("Database path: \(storeURL.path)")
        } else {
            print("Failed to find the Core Data store path.")
        }
    }
}

