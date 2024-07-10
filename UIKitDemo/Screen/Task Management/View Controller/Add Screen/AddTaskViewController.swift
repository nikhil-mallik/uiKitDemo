//
//  AddTaskViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var titleTxtFd: UITextField!
    @IBOutlet weak var descTxtFd: UITextView!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Variable
    let viewModel = TaskManagerViewModel.shared
    private var selectedPriority: TaskPriority?
    private var selectedStatus: TaskStatus?
    var tasksInfo : TaskModel?
    var isTaskEditing: Bool = false
    var taskId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        checkForEditing()
    }
    
    // MARK: Buttons Action
    // show priority action
    @IBAction func priorityBtn(_ sender: Any) {
        showPriorityAlert()
    }
    
    // show status action
    @IBAction func statusBtnAction(_ sender: Any) {
        showStatusAlert()
    }
    
    // submit data action
    @IBAction func submitBtnAction(_ sender: Any) {
        saveProfile()
    }
}

// MARK: - Extension for shared instance
extension AddTaskViewController {
    static func sharedIntance() -> AddTaskViewController {
        return AddTaskViewController.instantiateFromStoryboard("AddTaskViewController")
    }
}

// MARK: - Extension for Helper Method
extension AddTaskViewController {
    
    // MARK: - setupTextViews
    func setupTextViews() {
        descTxtFd.isScrollEnabled = false
        descTxtFd.layer.borderWidth = 1.0
        descTxtFd.layer.borderColor = UIColor.systemGray3.cgColor
        descTxtFd.layer.cornerRadius = 5.0
    }
    
    // Show alert to select task priority.
    func showPriorityAlert() {
        showEnumAlert(title: "Select Priority", message: "Choose the task priority", enumType: TaskPriority.self) { selectedPriority in
            self.updateTaskPriority(selectedPriority)
            self.selectedPriority = selectedPriority
        }
    }
    
    // Show alert to select task status.
    func showStatusAlert() {
        showEnumAlert(title: "Select Status", message: "Choose the task status", enumType: TaskStatus.self) { selectedStatus in
            self.updateTaskStatus(selectedStatus)
            self.selectedStatus = selectedStatus
        }
    }
    
    // Update the status button with the selected task status.
    func updateTaskStatus(_ status: TaskStatus) {
        statusButton.setTitle(status.rawValue, for: .normal)
        statusButton.backgroundColor = status.backgroundColor.withAlphaComponent(0.5)
    }
    
    // Update the priority button with the selected task priority.
    func updateTaskPriority(_ priority: TaskPriority) {
        priorityButton.setTitle(priority.rawValue, for: .normal)
        priorityButton.backgroundColor = priority.backgroundColor.withAlphaComponent(0.5)
    }
    
    // MARK: - addDataToArray
    func addDataToArray() {
        guard let title = titleTxtFd.text, !title.isEmpty,
              let desc = descTxtFd.text, !desc.isEmpty,
              let priority = selectedPriority,
              let status = selectedStatus else {
            AlertHelper.showAlert(withTitle: "Alert", message: "All fields are required", from: self)
            return
        }
        let newTaskID = (viewModel.tasks.last?.id ?? 0) + 1
        let newTask = TaskModel(
            id: newTaskID,
            title: title,
            description: desc,
            priority: priority,
            dueDate: dueDate.date,
            metadata: [.status: status.rawValue, .creationDate: Date()]
        )
        viewModel.addTask(newTask)
        AlertHelper.showAlert(withTitle: "Success", message: "Task added successfully", from: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - saveProfile
    func saveProfile() {
        if isTaskEditing {
            updateTask()
        } else {
             addDataToArray()
        }
    }
    
    // Check if the view controller is in editing mode and prefill task details if necessary.
    func checkForEditing() {
        if isTaskEditing == true {
            prefillTaskDetails()
        } else {
            clearTaskFields()
        }
    }
    
    // Clear all task input fields.
    func clearTaskFields() {
        titleTxtFd.text = ""
        descTxtFd.text = ""
        priorityButton.setTitle("Select Priority", for: .normal)
        statusButton.setTitle("Select Status", for: .normal)
        selectedStatus = nil
        selectedPriority = nil
        dueDate.date = Date()
    }
    
    // Prefill task details for editing.
    func prefillTaskDetails() {
        guard let taskData = tasksInfo else { return }
        titleTxtFd.text = taskData.title
        descTxtFd.text = taskData.desc
        updateTaskPriority(taskData.priority)
        selectedPriority = taskData.priority
        dueDate.date = taskData.dueDate
        priorityButton.setTitle(taskData.priority.rawValue, for: .normal)
        if let status = (taskData.metadata[.status] as? String) {
            if let taskStatus = TaskStatus(rawValue: status) {
                selectedStatus = taskStatus
                updateTaskStatus(taskStatus)
            } else {
                statusButton.setTitle(status, for: .normal)
                statusButton.backgroundColor = .systemIndigo
            }
        }
    }
    
    // Update an existing task in the view model's task list.
    func updateTask() {
        guard let title = titleTxtFd.text, !title.isEmpty,
              let desc = descTxtFd.text, !desc.isEmpty,
              let priority = selectedPriority,
              let status = selectedStatus else {
            AlertHelper.showAlert(withTitle: "Alert", message: "All fields are required", from: self)
            return
        }
       
        let newTask = TaskModel(
            id: taskId,
            title: title,
            description: desc,
            priority: priority,
            dueDate: dueDate.date,
            metadata: [.status: status.rawValue, .creationDate: Date()]
        )
        viewModel.editTask(withId: taskId, with: newTask)
        AlertHelper.showAlert(withTitle: "Success", message: "Task updated successfully", from: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
