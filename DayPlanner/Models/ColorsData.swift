//
//  ColorsData.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/11/2022.
//

import UIKit

struct ColorsData {
    
    static let shared = ColorsData()
    
    private init() {}
    
    let colorNames = [R.color.lightCoral.name, R.color.lightCobaltBlue.name, R.color.graniteGray.name, R.color.middleYellowRed.name, R.color.brightLavender.name, R.color.mediumAquamarine.name]
}
