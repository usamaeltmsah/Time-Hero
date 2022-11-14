//
//  SettingsData.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/11/2022.
//

import Foundation

struct SettingsData: Codable {
//    var isSettingsApplyToAll = false

    var isClicked: Bool = false
    
    var OnClickGlobalSettings: [Bool] = [false, false, false, false, false]
    var alwaysGlobalSettings: [Bool] = [false, false, false, false, false]

    var onClickGlobalDisplayCard: CardDisplayType = .defualt
    var alwaysGlobalDisplayCard: CardDisplayType = .defualt
    
    var isAppOpenedForDay: [Int:Bool] = [0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false]
    
    var isOnClickExpandable: Bool? = false
    var isAlwaysExpandable: Bool? = false
}
