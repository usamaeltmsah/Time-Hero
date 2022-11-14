//
//  NewTaskNavigationController.swift
//  DayPlanner
//
//  Created by Usama Fouad on 17/03/2021.
//

import UIKit

class NewTaskNavigationController: UINavigationController {

    var deleg: WeekDaysViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deleg?.dayPlansTV.reloadData()
    }

}
