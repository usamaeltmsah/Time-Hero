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
        saveData()
    }
}
var currentDayDoneCards = [PlanCard]()  {
    didSet {
        daysPlans[selectedDayInd, default: []][1] = currentDayDoneCards
    }
}

var isSettingsApplyToAll = false

func saveData() {
    let jsonEncoder = JSONEncoder()
            
    if let savedData = try? jsonEncoder.encode(daysPlans) {
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "daysPlans")
    } else {
        print("Failed to save data")
    }
        
}


func loadData() -> Bool {
    let defaults = UserDefaults.standard
            
    if let data = defaults.object(forKey: "daysPlans") as? Data {
        let jsonDecoder = JSONDecoder()
        
        do {
            daysPlans = try jsonDecoder.decode([Int:[[PlanCard]]].self, from: data)
            return true
        } catch {
            print("Couldn't load the cards!")
        }
    }
            return false
}
