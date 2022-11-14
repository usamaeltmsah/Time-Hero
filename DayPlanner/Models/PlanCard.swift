//
//  Card.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/11/2022.
//

import Foundation

struct PlanCard: Codable {
    var taskTitle: String?
    var taskCategory: String?
    var taskDescription: String?
    
    var hasDescription: Bool?
    
    var selectedColorIndex: Int?
    var taskColorName: String?
    
    var taskTime: Date?
    var taskLenght: String?
    var hours: Int?
    var minutes: Int?
    
//    var onClickCardDisplay: CardDisplayType?
//    var alwaysOnCardDisplay: CardDisplayType?
    var isClicked: Bool? = false
    
    var isDone: Bool? = false
    
//    var onClickSettings: [Bool]!
//    var alwaysOnSettings: [Bool]!
//
//    var isOnClickExpandable: Bool? = false
//    var isAlwaysExpandable: Bool? = false
    
    static func getTaskLen(for card: PlanCard) -> String? {
        var taskLength = ""
        if let hr = card.hours {
            taskLength += "\(hr)h "
        }
        
        if let mn = card.minutes {
            taskLength += "\(mn)m"
        }
        
        return taskLength
    }
    
    static func getFormatedFromTime(for card: PlanCard) -> String {
        return card.taskTime?.dateString(with: "HH:mm") ?? ""
    }
    
    static func getFormatedToTime(for card: PlanCard) -> String {
        var toDate = card.taskTime
        
        if let hrs = card.hours {
            toDate?.addTimeInterval(TimeInterval(hrs * 60 * 60))
        }
        
        if let mins = card.minutes {
            toDate?.addTimeInterval(TimeInterval(mins * 60))
        }
        
        return toDate?.dateString(with: "HH:mm") ?? getFormatedFromTime(for: card)
    }
}
