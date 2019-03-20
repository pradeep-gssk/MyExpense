//
//  Constants.swift
//  MyExpense
//
//  Created by Guduru, Pradeep(AWF) on 2/26/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

let months = ["January", "Febrary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]


enum DateType: Int {
    case date
    case month
    case year
}

enum ViewType: Int {
    case show
    case add
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
