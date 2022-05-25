//
//  TaskDetailViewController.swift
//  To-Do
//
//  Created by Mukul on 22/05/22.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
    
    var tasks: [NSManagedObject] = []
    @IBOutlet weak var taskTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "taskTitleCell")
        taskTableView.register(UINib(nibName: "TaskDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "taskDetailCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    func fetchData(){
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        
        switch (currentPage){
            
            case .Today:
                let today = Date()
                fetchRequest.predicate = NSPredicate(format: "(dateStamp => %@) AND (dateStamp <= %@)", DateHelper.startOfDay(day: today) as NSDate, DateHelper.endOfDay(day: today) as NSDate)
            break
            case .Tomorrow:
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
                let dateTomorrow = Calendar.current.date(from: tomorrow)!
                fetchRequest.predicate = NSPredicate(format: "(dateStamp => %@) AND (dateStamp <= %@)", DateHelper.startOfDay(day: dateTomorrow) as NSDate, DateHelper.endOfDay(day: dateTomorrow) as NSDate)
            break
            case .Upcoming:
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let upcomingDays = DateComponents(year: now.year, month: now.month, day: now.day! + 2)
                let dateUpcomingDays = Calendar.current.date(from: upcomingDays)!
                fetchRequest.predicate = NSPredicate(format: "(dateStamp => %@)", DateHelper.startOfDay(day: dateUpcomingDays) as NSDate)
            break
            default:
                let today = Date()
                fetchRequest.predicate = NSPredicate(format: "(dateStamp => %@) AND (dateStamp <= %@)", DateHelper.startOfDay(day: today) as NSDate, DateHelper.endOfDay(day: today) as NSDate)
            break
        }
        
        //3
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print(tasks.count)
            print(tasks)
            self.taskTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        newView.delegate = self
        taskAction = .add
        newView.modalPresentationStyle = .pageSheet
        self.present(newView, animated: true, completion: nil)
    }
    
    func update(task: NSManagedObject) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        newView.delegate = self
        taskAction = .modify
        newView.task = task
        newView.modalPresentationStyle = .pageSheet
        self.present(newView, animated: true, completion: nil)
    }
    
    
    func delete(task: NSManagedObject){
        taskAction = .delete
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        print(task)
        managedContext.delete(task)
        
        //3
        do {
            try managedContext.save()
        } catch let error as NSError {
            //Handle error
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
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

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count * 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskTitleCell", for: indexPath) as! TaskTitleTableViewCell
            
            let task = tasks[indexPath.row/2]
            cell.taskName.text = task.value(forKeyPath: "title") as? String
            
            let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short

            if let date = task.value(forKeyPath: "dateStamp") as? Date {
                let strDate = dateFormatter.string(from: date)
                print(strDate)
                cell.taskTime.text = strDate
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskDetailCell", for: indexPath) as! TaskDetailTableViewCell
            
            cell.delegate = self
            let task = tasks[indexPath.row/2]
            if let tD = task.value(forKeyPath: "detail") as? String {
                cell.taskDetail.text = tD
            }
            cell.task = task
            
            return cell
        }
    }
    
}

extension TaskDetailViewController: AddTaskViewControllerDelegate {
    func updateTable() {
        self.fetchData()
        self.taskTableView.reloadData()
    }
}

extension TaskDetailViewController: TaskDetailTableViewCellDelegate {
    func deleteTask(_ task: NSManagedObject) {
        self.delete(task: task)
        self.fetchData()
        self.taskTableView.reloadData()
    }
    
    func modifyTask(_ task: NSManagedObject) {
        self.update(task: task)
    }
    
    
}

class DateHelper{
    static func startOfDay(day: Date) -> Date {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlags: NSCalendar.Unit = [.minute, .hour, .day, .month, .year]
        var todayComponents = gregorian!.components(unitFlags, from: day)
        todayComponents.hour = 0
        todayComponents.minute = 0
        return (gregorian?.date(from: todayComponents))!
    }

    static func endOfDay(day: Date) -> Date {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlags: NSCalendar.Unit = [.minute, .hour, .day, .month, .year]
        var todayComponents = gregorian!.components(unitFlags, from: day)
        todayComponents.hour = 23
        todayComponents.minute = 59
        return (gregorian?.date(from: todayComponents))!
    }
}
