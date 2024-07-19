//
//  DatabaseManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 16/07/24.
//

import UIKit
import CoreData

class DatabaseManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addUser(_ user: UserDataModel) {
        let userEntity = UserEntity(context: context)
        addUpdateUser(userEntity: userEntity, user: user)
    }
    
    func updateUser(user: UserDataModel, userEntity: UserEntity) {
        addUpdateUser(userEntity: userEntity, user: user)
    }
    
    private func addUpdateUser(userEntity: UserEntity, user: UserDataModel) {
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.bioData = user.bioData
        userEntity.userImage = user.userImage
        userEntity.userId = user.userId
        userEntity.dob = user.dob
        userEntity.mobileNumber = Int64(user.mobileNumber)
        saveContext()
    }
    
    func fetchUsers() -> [UserEntity] {
        var users: [UserEntity] = []
        
        do {
            users = try context.fetch(UserEntity.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }
        
        return users
    }
    
    func saveContext() {
        do {
            try context.save()
        }catch {
            print("User saving error:", error)
        }
        printDatabasePath()
    }
    
    func deleteUser(userEntity: UserEntity) {
        
        if let imageURL = FileManagerHelper.getImageURL(for: userEntity.userImage) {
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                print("Error removing image from documents directory:", error)
            }
        }
        
        context.delete(userEntity)
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
