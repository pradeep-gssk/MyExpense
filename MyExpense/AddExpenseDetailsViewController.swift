//
//  AddExpenseDetailsViewController.swift
//  MyExpense
//
//  Created by Guduru, Pradeep(AWF) on 2/26/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class AddExpenseDetailsViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var monthyearField: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var dateTitle: UILabel!
    
    var month: Month!
    var selectedDate: Dates!
    var expense: Expense!
    
    var dateType: DateType = .date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountField.becomeFirstResponder()
        
        switch self.dateType {
        case .date:
            self.dateTitle.text = "Select Date"
            self.dateField.inputView = self.datePicker
            self.datePicker.datePickerMode = .date
            self.dateField.text = self.convertDateFormater(self.datePicker.date)
            self.monthyearField.isHidden = true
        case .month:
            self.dateTitle.text = "Selected Month"
            self.monthyearField.text = (month.name ?? "") + ", " + "2019"
            self.dateField.isHidden = true
        case .year:
            self.dateTitle.text = "Selected Year"
            self.monthyearField.text = "2019"
            self.dateField.isHidden = true
        }
    }
    
    func convertDateFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date)
    }
    
    @IBAction func didChangeDate(_ sender: Any) {
        self.dateField.text = self.convertDateFormater(self.datePicker.date)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        guard let text = self.amountField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let amount = text.toDouble() else { return }
        
        switch self.dateType {
        case .date:
            let date = Dates(context: context)
            date.amount = amount
            date.date = self.datePicker.date
            
            self.month.addToDate(date)
            
            self.month.amount += amount
            self.month.expenses?.total += amount
        case .month:
            self.month.amount = amount
            self.month.expenses?.total += amount
        case .year:
            self.expense.total = amount
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Failed saving")
        }
    }
}
