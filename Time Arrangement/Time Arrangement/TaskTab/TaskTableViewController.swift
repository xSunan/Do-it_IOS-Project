//
//  TaskTableViewController.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/5.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit


struct Task {
    var title: String?
    var startDate: Date?
    var type: Frequency?
    var endDate: Date?
    var duration: Float?
    var finishedPart: Float?
    var distribution: [Float]?
}


enum Frequency {
    case Once, Day, Week, Month
}
class TaskTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TasksTimeDelegate {
   
    
    
    @IBOutlet var newTaskText: UITextField!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    var allTasks = [Task]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTableView.rowHeight = 80
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self
        self.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)

    }
    
    /* When user set their time*/
    func setTime(date: Date, isStart: Bool, indexPath: IndexPath) {
        print("settime")
        if (isStart == true) {
            self.allTasks[indexPath.row].startDate = date
        } else {
            self.allTasks[indexPath.row].endDate = date
        }
//        self.taskTableView.reloadData()
        self.taskTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    @objc func addButtonTapped(_ button: UIButton!){
        var newTask = Task()
        newTask.title = newTaskText.text!
        allTasks.append(newTask)
        taskTableView.reloadData()
//        let indexPath = IndexPath(row: allTasks.count-1, section: 0)
//        taskTableView.beginUpdates()
//        taskTableView.insertRows(at: [indexPath], with: .automatic)
//        taskTableView.endUpdates()
//
        newTaskText.text = ""
//        view.endEditing(true)
        
    }
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.taskTitle.text = self.allTasks[indexPath.row].title ?? "No Name"
        cell.startDate.text = self.allTasks[indexPath.row].startDate?.convertToString(dateformat: .date)
        cell.endDate.text = self.allTasks[indexPath.row].endDate?.convertToString(dateformat: .date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /* Swipe acction */
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = allTasks[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit",
          handler: { (action, view, completionHandler) in
            self.updateTask(task: task, indexPath: indexPath)
        })
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete",
          handler: { (action, view, completionHandler) in
          self.deleteTask(task: task, indexPath: indexPath)

        })
        
        deleteAction.image = UIImage(systemName: "bin.xmark")
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])

        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let setTimerAction = UIContextualAction(style: .normal, title: "timer",
          handler: { (action, view, completionHandler) in
            self.setTimer(indexPath: indexPath)
        })
        
        setTimerAction.image = UIImage(systemName: "alarm")
        let configuration = UISwipeActionsConfiguration(actions: [setTimerAction])
        return configuration
    }
    
    /* When swipe and click the alarm's image*/
    func setTimer(indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "setTimer") as? TasksTimeViewController{
            vc.taskIndexPath = indexPath
            vc.delegate = self
            vc.inputDates = [Date]()
            if(self.allTasks[indexPath.row].startDate != nil) {
                vc.inputDates.append(self.allTasks[indexPath.row].startDate!)
            } else {
                vc.inputDates.append(NSDate() as Date)
            }
            
            if(self.allTasks[indexPath.row].endDate != nil) {
                vc.inputDates.append(self.allTasks[indexPath.row].endDate!)
            } else {
                vc.inputDates.append(NSDate() as Date)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    /* update the task's name*/
    func updateTask(task: Task, indexPath: IndexPath){
        let alert = UIAlertController(title: "Rename", message: "Rename your task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {(action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                self.allTasks[indexPath.row].title = textToEdit
                self.taskTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        alert.addTextField()
        guard (alert.textFields?.first) != nil else {
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated:true)
    }
    
    /* delete the task*/
    func deleteTask(task: Task, indexPath: IndexPath){
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete the task?",preferredStyle: UIAlertController.Style.alert)
        let delete = UIAlertAction(title: "Yes", style: .default){ (action) in
            self.allTasks.remove(at: indexPath.row)
            self.taskTableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        
        let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? TasksTimeViewController {
//            destination.delegate = self
//            destination.taskIndexPath = self.taskTableView.indexPathForSelectedRow!
//        }
//    }
    
    
    
    
}
