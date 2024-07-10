//
//  TaskManagerViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 09/07/24.
//

import UIKit

class TaskManagerViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var navAddButton: UIBarButtonItem!
    @IBOutlet weak var taskTableView: UITableView!
    
    // MARK: Variable
    let viewModel = TaskManagerViewModel.shared
    private var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observeTasks()
    }
    
    // Observe changes to the tasks property in the view model.
    func observeTasks() {
        observation = viewModel.observe(\.tasks, options: [.new]) { [weak self] (_, change) in
            self?.taskTableView.reloadData()
        }
    }
    
    func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    // MARK: - Actions
    @IBAction func navAddBtnAction(_ sender: Any) {
        let addTaskVC = AddTaskViewController.sharedIntance()
        addTaskVC.navigationItem.title = "Add Task"
        self.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}

// MARK: - Extension for shared instance
extension TaskManagerViewController {
    static func sharedIntance() -> TaskManagerViewController {
        return TaskManagerViewController.instantiateFromStoryboard("TaskManagerViewController")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TaskManagerViewController: UITableViewDataSource {
    
    // Return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTasks().count
    }
    
    // Provide a cell object for each row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = viewModel.getTasks()[indexPath.row]
        cell.task = task
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskManagerViewController: UITableViewDelegate {
    // MARK: - Table Cell Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Edit action to update the selected task.
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let editData = self.viewModel.getTasks()[indexPath.row]
            let addTaskVC = AddTaskViewController.sharedIntance()
            addTaskVC.navigationItem.title = "Update Task"
            addTaskVC.taskId = editData.id
            addTaskVC.tasksInfo = editData
            addTaskVC.isTaskEditing = true
            self.navigationController?.pushViewController(addTaskVC, animated: true)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.systemIndigo
        
        // Delete action to remove the selected task.
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let idToDelete = self.viewModel.getTasks()[indexPath.row].id
            self.viewModel.deleteTask(withId: idToDelete)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
