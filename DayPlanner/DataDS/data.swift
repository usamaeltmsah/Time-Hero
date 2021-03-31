//
//  data.swift
//  DayPlanner
//
//  Created by Usama Fouad on 16/03/2021.
//

import UIKit
import WidgetKit


var selectedDayInd: Int! = 0

// daysPlans: is a dictionary that holds the day index, and 1D array which contains allCards (Done and not done).
var daysPlans = [Int:[[PlanCard]]]() {
    didSet {
        saveData()
    }
}

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

var colorButtons = [UIButton]()

let arrowsImages = ["redarrow", "bluearrow", "blackarrow", "orange", "purplearrow", "greenarrow"]

var setData = SettingsData()

struct SettingsData: Codable {
//    var isSettingsApplyToAll = false

    var isClicked: Bool! = false
    
    var OnClickGlobalSettings: [Bool] = [false, false, false, false, false]
    var alwaysGlobalSettings: [Bool] = [false, false, false, false, false]

    var onClickGlobalDisplayCard: DisplayType! = .defualt
    var alwaysGlobalDisplayCard: DisplayType! = .defualt
    
    var isAppOpenedForDay: [Int:Bool] = [0:false, 1:false, 2:false, 3:false, 4:false, 5:false, 6:false]
}

func saveData() {
    let jsonEncoder = JSONEncoder()
    let defaults = UserDefaults(suiteName: "group.usamaWidgetCache")
    
    saveSettings()
    if let savedData = try? jsonEncoder.encode(daysPlans) {
        defaults?.set(savedData, forKey: "daysPlans")
        WidgetCenter.shared.reloadAllTimelines()
    } else {
        print("Failed to save data")
    }
        
}


func saveSettings() {
    let jsonEncoder = JSONEncoder()
    let defaults = UserDefaults.standard
    
    if let savedData = try? jsonEncoder.encode(setData) {
        defaults.set(savedData, forKey: "settingData")
    } else {
        print("Failed to save data")
    }
}

func loadData() -> Bool {
    let defaults = UserDefaults(suiteName: "group.usamaWidgetCache")
        loadSettings()
    if let data = defaults?.object(forKey: "daysPlans") as? Data {
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

func loadSettings() {
    let defaults = UserDefaults.standard
    
    if let data = defaults.object(forKey: "settingData") as? Data {
        let jsonDecoder = JSONDecoder()
        
        do {
            setData = try jsonDecoder.decode(SettingsData.self, from: data)
        } catch {
            print("Couldn't load the settings!")
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
