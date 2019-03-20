//
//  MonthsTableViewController.swift
//  MyExpense
//
//  Created by Guduru, Pradeep(AWF) on 2/26/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit
import CoreData

class MonthsTableViewController: UITableViewController {

    var expense: Expense!
    var dateType: DateType = .date
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Month> = {
        let fetchRequest: NSFetchRequest<Month> = Month.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "month", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "expenses = %@", expense)
        let fetchedResultsController = NSFetchedResultsController<Month>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    @IBOutlet weak var total: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        if let type = self.expense?.type {
            self.dateType = DateType(rawValue: Int(type)) ?? .date
        }
        
        self.title = "Months"
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            print("Error")
        }
        
        self.calculateSum()
    }

    func calculateSum() {
        let sum = self.fetchedResultsController.fetchedObjects?.reduce(0) { $0 + ($1.amount) } ?? 0.0
        self.total.title = String(format: "$%.2f", sum)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DatesTableViewController,
            let month = sender as? Month {
            viewController.month = month
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthsCell", for: indexPath)
        self.configureCell(cell, at: indexPath)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let month = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = month.name
        cell.accessoryType = (expense.type == 0) ? .disclosureIndicator : .none
        cell.detailTextLabel?.text = String(format: "$%.2f", month.amount)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let month = self.fetchedResultsController.object(at: indexPath)

        switch self.dateType {
        case .date:
            self.performSegue(withIdentifier: "ShowDatesView", sender: month)
        default:
            break
        }
    }
}

extension MonthsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = self.tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
            
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        self.calculateSum()
    }
}
