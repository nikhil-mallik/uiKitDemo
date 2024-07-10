//
//  TaskTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 09/07/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskBackgroundView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priorityLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var createdLbl: UILabel!
    
    var task: TaskModel? {
        didSet {
            taskDetailsConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskBackgroundView.clipsToBounds = false
        taskBackgroundView.layer.cornerRadius = 15
        taskView.layer.cornerRadius = 15
        taskBackgroundView.backgroundColor = UIColor.systemGray3
    }
    
    func taskDetailsConfiguration() {
        guard let tasks = task else { return }
        titleLbl.text = "Title: " + tasks.title
        descLbl.text = "Desc: " + tasks.desc
        priorityLbl.text = "Priority: " + tasks.priority.rawValue
        priorityLbl.textColor = tasks.priority.backgroundColor
        if let status = (tasks.metadata[.status] as? String) {
            if let taskStatus = TaskStatus(rawValue: status) {
                statusLbl.text = "Status: " + status
                statusLbl.textColor = taskStatus.backgroundColor
            } else {
                statusLbl.text = "Status: " + status
                statusLbl.textColor = .black
            }
        }
        dueDateLbl.text = "Due: \(getDateOnly(from: tasks.dueDate))"
        if let creationDate = tasks.metadata[.creationDate] as? Date {
            createdLbl.text = "Created: \(getDateOnly(from: creationDate))"
        }
    }
    
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
