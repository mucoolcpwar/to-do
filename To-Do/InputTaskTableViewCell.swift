//
//  InputTaskTableViewCell.swift
//  To-Do
//
//  Created by Mukul on 22/05/22.
//

import UIKit

class InputTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UITextView!
    @IBOutlet weak var taskDetail: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateStamp: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.buildTextViewBorder(textView: taskTitle)
        self.buildTextViewBorder(textView: taskDetail)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func buildTextViewBorder(textView: UITextView){
        let borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short

        let strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)
        dateStamp = datePicker.date
    }
}
