//
//  TaskManagerModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 09/07/24.
//

import UIKit

enum TaskPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var backgroundColor: UIColor {
        switch self {
        case .low:
            return UIColor.systemGreen
        case .medium:
            return UIColor.orange
        case .high:
            return UIColor.red
        }
    }
}

enum TaskMetadataKey: String {
    case creationDate
    case status
}

enum TaskStatus: String, CaseIterable {
    case Pending = "Pending"
    case In_Progress = "In_Progress"
    case Completed = "Completed"
    
    var backgroundColor: UIColor {
        switch self {
        case .Pending:
            return UIColor.red
        case .In_Progress:
            return UIColor.purple
        case .Completed:
            return UIColor.systemGreen
        }
    }
}

class TaskModel: NSObject {
    var id: Int
    @objc dynamic var title: String
    @objc dynamic var desc: String
    var priority: TaskPriority
    @objc dynamic var dueDate: Date
    var metadata: [TaskMetadataKey: Any]
    
    init(id: Int, title: String, description: String, priority: TaskPriority, dueDate: Date, metadata: [TaskMetadataKey: Any] = [:]) {
        self.id = id
        self.title = title
        self.desc = description
        self.priority = priority
        self.dueDate = dueDate
        self.metadata = metadata
    }
}
