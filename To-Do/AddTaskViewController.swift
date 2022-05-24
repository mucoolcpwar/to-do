//
//  AddTaskViewController.swift
//  To-Do
//
//  Created by Mukul on 22/05/22.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func updateTable()
}

class AddTaskViewController: UIViewController {
    
    var delegate : AddTaskViewControllerDelegate?
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
        
        let task = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        task.setValue(dateStamp, forKeyPath: "dateStamp")
        task.setValue(taskDetail, forKeyPath: "detail")
        task.setValue(taskTitle, forKeyPath: "title")
        
        // 4
        do {
            try managedContext.save()
            self.dismiss(animated: true) {
                self.delegate?.updateTable()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        return cell
    }
    
    
}


