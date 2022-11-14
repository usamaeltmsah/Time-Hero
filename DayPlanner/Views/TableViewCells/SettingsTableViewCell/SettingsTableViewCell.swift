//
//  SettingsTableViewCell.swift
//  DayPlanner
//
//  Created by Usama Fouad on 09/11/2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var isEnabledSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(settingsModel: SettingModel) {
        titleLabel.text = settingsModel.title
        isEnabledSwitch.isOn = settingsModel.isEnabled
    }
}
