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
    
//    func getSelectedColor() -> UIColor! {
//        return taskColorButton.backgroundColor
//    }
    
    func getStringDate() -> String {
        return taskTime.dateString(with: "HH:MM")
    }
}

extension Date {
    func dateString(with strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
}
