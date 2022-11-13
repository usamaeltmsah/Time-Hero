//
//  DayPlanCardLeftTopOnCardTableViewCell.swift
//  DayPlanner
//
//  Created by Usama Fouad on 09/11/2022.
//

import UIKit

class DayPlanCardLeftTopOnCardTableViewCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var leftFromTimeLabel: UILabel!
    @IBOutlet var left1TimeSeperator: UILabel!
    @IBOutlet var left2TimeSeperator: UIImageView!
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
    @IBOutlet var leftCardTimeView: UIStackView!
    @IBOutlet var topCardTimeView: UIView!
    @IBOutlet var onCardTimeView: UIStackView!
    @IBOutlet var cardContentStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        left1TimeSeperator.font = UIFont(name: "Poppins-Medium", size: 12)
        
        topFromTimeLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        topFromTimeSeperator.font = UIFont(name: "Poppins-Bold", size: 12)
        topToTimeLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        
        onCardFromTimeLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        onCardTimeSeperator.font = UIFont(name: "Poppins-SemiBold", size: 16)
        onCardToTimeLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
    }
}
