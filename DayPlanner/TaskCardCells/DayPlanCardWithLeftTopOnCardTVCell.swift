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
    @IBOutlet var leftCardTimeView: UIView!
    @IBOutlet var topCardTimeView: UIView!
    @IBOutlet var onCardTimeView: UIStackView!
    @IBOutlet var cardContentStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        left1TimeSeperator.font = UIFont(name: "Poppins-Medium", size: 12)
        
        topFromTimeLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        topFromTimeSeperator.font = UIFont(name: "Poppins-Bold", size: 12)
        topToTimeLabel.font = UIFont(name: "Poppins-Bold", size: 12)
        
        onCardFromTimeLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        onCardTimeSeperator.font = UIFont(name: "Poppins-SemiBold", size: 16)
        onCardToTimeLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }

}
