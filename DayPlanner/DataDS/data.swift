//
//  data.swift
//  DayPlanner
//
//  Created by Usama Fouad on 16/03/2021.
//

import UIKit



var selectedDayInd: Int! = 0

// daysPlans: is a dictionary that holds the day index, and 1D array which contains allCards (Done and not done).
var daysPlans = [Int:[[PlanCard]]]()

var currentDayUnDoneCards = [PlanCard]() {
    didSet {
        daysPlans[selectedDayInd, default: []][0] = currentDayUnDoneCards
    }
}
var currentDayDoneCards = [PlanCard]()  {
    didSet {
        daysPlans[selectedDayInd, default: []][1] = currentDayDoneCards
    }
}

var isSettingsApplyToAll = false
