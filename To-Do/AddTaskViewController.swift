//
//  AddTaskViewController.swift
//  To-Do
//
//  Created by Mukul on 22/05/22.
//

import UIKit
import CoreData

enum TaskAction {
    case add, modify, delete
}
var taskAction: TaskAction?

protocol AddTaskViewControllerDelegate {
    func updateTable()
}

class AddTaskViewController: UIViewController {
    
    var delegate : AddTaskViewControllerDelegate?
    var task: NSManagedObject?
    var dateStamp: Date?
    var taskDetail: String?
    var taskTitle: String?
    
    @IBOutlet weak var addTaskTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addTaskTableView.delegate = self
        addTaskTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addTaskTableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        switch (taskAction) {
        case .add:
            taskTitle = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).taskTitle.text
            taskDetail = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).taskDetail.text
            if let selectedDate = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).dateStamp {
                dateStamp = selectedDate
            } else {
                dateStamp = Date()
            }
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            // 1
            let managedContext =
            appDelegate.persistentContainer.viewContext
            
            // 2
            let entity =
            NSEntityDescription.entity(forEntityName: "Tasks",
                                       in: managedContext)!
            
            let newTask = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
            
            // 3
            newTask.setValue(dateStamp, forKeyPath: "dateStamp")
            newTask.setValue(taskDetail, forKeyPath: "detail")
            newTask.setValue(taskTitle, forKeyPath: "title")
            // 4
            do {
                try managedContext.save()
                self.dismiss(animated: true) {
                    self.delegate?.updateTable()
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            break
        case .modify:
            taskTitle = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).taskTitle.text
            taskDetail = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).taskDetail.text
            if let selectedDate = (addTaskTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! InputTaskTableViewCell).dateStamp {
                dateStamp = selectedDate
            } else {
                dateStamp = Date()
            }
            
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            // 1
            let managedContext =
            appDelegate.persistentContainer.viewContext
            
            // 3
            self.task?.setValue(dateStamp, forKeyPath: "dateStamp")
            self.task?.setValue(taskDetail, forKeyPath: "detail")
            self.task?.setValue(taskTitle, forKeyPath: "title")
            // 4
            do {
                try managedContext.save()
                self.dismiss(animated: true) {
                    self.delegate?.updateTable()
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            break
        default:
            break
        }
        
    }
    @IBAction func cancelTask(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addTaskTableView.dequeueReusableCell(withIdentifier: "addTaskCell", for: indexPath) as! InputTaskTableViewCell
        
        switch (taskAction) {
        case .add:
            cell.taskTitle.text = ""
            cell.taskDetail.text = ""
            cell.datePicker.date = Date()
            break
        case .modify:
            if let existingTitle = task!.value(forKeyPath: "title") as? String {
                cell.taskTitle.text = existingTitle
            }
            if let existingDetail = task!.value(forKeyPath: "detail") as? String {
                cell.taskDetail.text = existingDetail
            }
            if let existingDate = task!.value(forKeyPath: "dateStamp") as? Date {
                cell.datePicker.date = existingDate
            }
            break
        default:
            break
        }
        
        return cell
    }
    
    
}


