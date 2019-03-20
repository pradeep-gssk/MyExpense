//
//  AddExpenseViewController.swift
//  MyExpense
//
//  Created by Guduru, Pradeep(AWF) on 2/26/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var dateType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        guard let text = self.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let expense = Expense(context: context)
        expense.name = text
        expense.type = Int16(self.dateType)
        expense.year = 2019
        expense.total = 0
        
        let monthsSet = NSMutableSet()
        
        for (index, month) in months.enumerated() {
            let monthEntity = Month(context: context)
            monthEntity.name = month
            monthEntity.month = Int16(index)
            monthEntity.amount = 0.0
            monthsSet.add(monthEntity)
        }
        expense.months = monthsSet
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Failed saving")
        }
    }
    
    @IBAction func didChangeDateType(_ segmentedControl: UISegmentedControl) {
        self.dateType = segmentedControl.selectedSegmentIndex
    }
}
