//
//  TaskManagerViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 09/07/24.
//

import Foundation

class TaskManagerViewModel: NSObject {
    // MARK: - Singleton Instance
    static let shared = TaskManagerViewModel()
    private override init() {}
    
    @objc dynamic var tasks: [TaskModel] = []
    
    // MARK: Add Function
    func addTask(_ task: TaskModel) {
        willChangeValue(forKey: "tasks")
        tasks.append(task)
        didChangeValue(forKey: "tasks")
    }
    
    // MARK: Fetch Function
    func getTasks() -> [TaskModel] {
        return tasks
    }
    
    // MARK: Edit Function
    func editTask(withId id: Int, with newTask: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            willChangeValue(forKey: "tasks")
            tasks[index] = newTask
            didChangeValue(forKey: "tasks")
        }
    }
    
    // MARK: Delete Function
    func deleteTask(withId id: Int) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            willChangeValue(forKey: "tasks")
            tasks.remove(at: index)
            didChangeValue(forKey: "tasks")
        }
    }
    
    // MARK: Clear Array
    func clearArray() {
        tasks.removeAll()
    }
}
