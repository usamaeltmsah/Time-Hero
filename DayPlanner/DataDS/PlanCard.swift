//
//  PlanCard.swift
//  DayPlanner
//
//  Created by Usama Fouad on 15/03/2021.
//

import UIKit

struct PlanCard : Hashable {
    var taskTitle: String!
    var taskCat: String!
    var taskDesc: String?
    
    var taskColorButton: UIButton!
    var selectedColorInd: Int!
    var taskColor: UIColor!
    
    var taskTime: Date!
    var taskLenght: String!
    var hours: Int!
    var minutes: Int!
    
    var cardDisplay: DisplayType!
    
    var onClickSettings: [Bool]!
    var alwaysOnSettings: [Bool]!
    
    func getTaskLen() -> String {
        var taskLength = ""
        if let hr = hours {
            taskLength += "\(hr)H "
        }
        
        if let mn = minutes {
            taskLength += "\(mn)M"
        }
        
        return taskLength
    }
    
    func getStringDate() -> String {
        return taskTime.dateString(with: "HH:mm")
    }
    
    func getToTime() -> String {
        var toDate = taskTime
        
        if let hrs = hours {
            toDate?.addTimeInterval(TimeInterval(hrs * 60 * 60))
        }
        
        if let mins = minutes {
            toDate?.addTimeInterval(TimeInterval(mins * 60))
        }
        
        return toDate?.dateString(with: "HH:mm") ?? getStringDate()
    }
}

extension Date {
    func dateString(with strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
