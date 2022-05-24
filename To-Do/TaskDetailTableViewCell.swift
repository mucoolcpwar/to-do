//
//  TaskDetailTableViewCell.swift
//  To-Do
//
//  Created by Mukul on 24/05/22.
//

import UIKit
import CoreData

protocol TaskDetailTableViewCellDelegate {
    func modifyTask(_ task: NSManagedObject)
    func deleteTask(_ task: NSManagedObject)
}

class TaskDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskDetail: UILabel!
    var task: NSManagedObject?
    
    var delegate: TaskDetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func modifyTask(_ sender: Any) {
        self.delegate?.modifyTask(task!)
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        self.delegate?.deleteTask(task!)
    }
}
