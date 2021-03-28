//
//  PlanCard.swift
//  DayPlanner
//
//  Created by Usama Fouad on 15/03/2021.
//

import UIKit

struct PlanCard : Hashable, Codable {
    var taskTitle: String!
    var taskCat: String!
    var taskDesc: String?
    
    var hasDescription: Bool!
    
    var selectedColorInd: Int!
    var taskColor: UIColor!
    
    var taskTime: Date!
    var taskLenght: String!
    var hours: Int!
    var minutes: Int!
    
    var OnClickcardDisplay: DisplayType!
    var AlwaysOncardDisplay: DisplayType!
    var isClicked = false
    
    var onClickSettings: [Bool]!
    var alwaysOnSettings: [Bool]!
    
    var isOnClickExpandable = false
    var isAlwaysExpandable = false
    
    enum CodingKeys: String, CodingKey {
        case taskTitle, taskCat, taskDesc, hasDescription, taskColor, selectedColorInd, taskTime, taskLenght, hours, minutes, OnClickcardDisplay, AlwaysOncardDisplay, onClickSettings, alwaysOnSettings, isClicked, isOnClickExpandable, isAlwaysExpandable
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)

        taskTitle = try? values?.decode(String.self, forKey: .taskTitle)
        taskCat = try? values?.decode(String.self, forKey: .taskCat)
        taskDesc = try? values?.decode(String.self, forKey: .taskDesc)
        hasDescription = try? values?.decode(Bool.self, forKey: .hasDescription)
        taskColor = try? values?.decode(MyColor.self, forKey: .taskColor).uiColor
        selectedColorInd = try? values?.decode(Int.self, forKey: .selectedColorInd)
        taskTime = try? values?.decode(Date.self, forKey: .taskTime)
        
        hours = try? values?.decode(Int.self, forKey: .hours)
        minutes = try? values?.decode(Int.self, forKey: .minutes)
        taskLenght = try? values?.decode(String.self, forKey: .taskLenght)
        OnClickcardDisplay = try? values?.decode(DisplayType.self, forKey: .OnClickcardDisplay)
        AlwaysOncardDisplay = try? values?.decode(DisplayType.self, forKey: .AlwaysOncardDisplay)
        onClickSettings = try? values?.decode([Bool].self, forKey: .onClickSettings)
        alwaysOnSettings = try? values?.decode([Bool].self, forKey: .alwaysOnSettings)
        
        isClicked = ((try values?.decode(Bool.self, forKey: .isClicked)) != nil)
        isOnClickExpandable = ((try values?.decode(Bool.self, forKey: .isOnClickExpandable)) != nil)
        isAlwaysExpandable = ((try values?.decode(Bool.self, forKey: .isAlwaysExpandable)) != nil)
    }
    
    init(taskTitle: String, taskCat: String, taskDesc: String?, taskColor: UIColor?, taskTime: Date?, hours: Int?, minutes: Int?) {
        self.taskTitle = taskTitle
        self.taskCat = taskCat
        self.taskDesc = taskDesc
        self.taskColor = taskColor
        self.taskTime = taskTime
        self.hours = hours
        self.minutes = minutes
    }
    
    init() {
        //
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encode(taskTitle, forKey: .taskTitle)
        try? container.encode(taskCat, forKey: .taskCat)
        try? container.encode(taskDesc, forKey: .taskDesc)
        try? container.encode(MyColor(uiColor: taskColor), forKey: .taskColor)
        try? container.encode(hasDescription, forKey: .hasDescription)
        try? container.encode(selectedColorInd, forKey: .selectedColorInd)
        try? container.encode(taskTime, forKey: .taskTime)
        
        try? container.encode(hours, forKey: .hours)
        try? container.encode(minutes, forKey: .minutes)
        try container.encode(taskLenght, forKey: .taskLenght)
        try? container.encode(OnClickcardDisplay, forKey: .OnClickcardDisplay)
        try? container.encode(AlwaysOncardDisplay, forKey: .AlwaysOncardDisplay)
        try? container.encode(onClickSettings, forKey: .onClickSettings)
        try? container.encode(alwaysOnSettings, forKey: .alwaysOnSettings)
        
        try? container.encode(isClicked, forKey: .isClicked)
        try? container.encode(isOnClickExpandable, forKey: .isOnClickExpandable)
        try? container.encode(isAlwaysExpandable, forKey: .isAlwaysExpandable)
    }
    
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
    
    func getFromTime() -> String {
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
        
        return toDate?.dateString(with: "HH:mm") ?? getFromTime()
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

struct MyColor: Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(uiColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
}
