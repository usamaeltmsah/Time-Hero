//
//  ExpandDescriptionTVCell.swift
//  DayPlanner
//
//  Created by Usama Fouad on 20/03/2021.
//

import UIKit

class DayPlanCardWithLeftTopOnCardTVCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var leftFromTimeLabel: UILabel!
    @IBOutlet var left1TimeSeperator: UILabel!
    @IBOutlet var left2TimeSeperator: UILabel!
    @IBOutlet var leftToTimeLabel: UILabel!
    @IBOutlet var topFromTimeLabel: UILabel!
    @IBOutlet var topFromTimeSeperator: UILabel!
    @IBOutlet var topToTimeLabel: UILabel!
    @IBOutlet var onCardFromTimeLabel: UILabel!
    @IBOutlet var onCardTimeSeperator: UILabel!
    @IBOutlet var onCardToTimeLabel: UILabel!
    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var taskCatLabel: UILabel!
    @IBOutlet var taskDescLabel: UILabel!
    @IBOutlet var taskLengthLabel: UILabel!
    @IBOutlet var leftCardTimeView: UIView!
    @IBOutlet var topCardTimeView: UIView!
    @IBOutlet var onCardTimeView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
