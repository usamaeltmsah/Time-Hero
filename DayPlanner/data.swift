//
//  data.swift
//  DayPlanner
//
//  Created by Usama Fouad on 16/03/2021.
//

import UIKit

var selectedDay: UIButton!
var daysButtons = [UIButton]()

var selectedDayInd: Int! = 0

// daysPlans: is a dictionary that holds the day index, and 1D array which contains allCards (Done and not done).
var daysPlans = [Int:[PlanCard]]()

var allCards = [PlanCard]() {
    didSet {
        daysPlans[selectedDayInd] = allCards
    }
}

