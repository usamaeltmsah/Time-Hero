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
    
    func configure(_ card: PlanCard) {
        let fromTime = PlanCard.getFormatedFromTime(for: card)
        let toTime = PlanCard.getFormatedToTime(for: card)
        leftFromTimeLabel.text = fromTime
        leftToTimeLabel.text = toTime
        topFromTimeLabel.text = fromTime
        topToTimeLabel.text = toTime
        onCardFromTimeLabel.text = fromTime
        onCardToTimeLabel.text = toTime
        taskTitleLabel.text = card.taskTitle
        taskCatLabel.text = card.taskCategory
        taskDescLabel.text = card.taskDescription
        taskLengthLabel.text = card.taskLenght
        cardView.backgroundColor = UIColor(named: card.taskColorName ?? "")
        if let taskColorName = card.taskColorName {
            let taskColor = UIColor(named: taskColorName)
            topFromTimeLabel.textColor = taskColor
            topFromTimeSeperator.textColor = taskColor
            topToTimeLabel.textColor = taskColor
        }
        if let selectedColorIndex = card.selectedColorIndex {
            left2TimeSeperator.image = UIImage(named: DataManager.shared.arrowsImages[selectedColorIndex])
        }
        
        if DataManager.shared.settingsData.isAlwaysExpandable ?? false && card.hasDescription ?? false {
            taskDescLabel.isHidden = false
        } else {
            taskDescLabel.isHidden = true
        }
    }
    
    func showLeft1Time() {
        hideAllHrs()
        leftCardTimeView.isHidden = false
        left1TimeSeperator.isHidden = false
        left2TimeSeperator.isHidden = true
        
        leftFromTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
        leftToTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
        
        leftFromTimeLabel.textColor = .black
        left1TimeSeperator.textColor = .black
        leftToTimeLabel.textColor = .black
    }
    
    func showLeft2Time(_ colorName: String?) {
        hideAllHrs()
        leftCardTimeView.isHidden = false
        left1TimeSeperator.isHidden = true
        left2TimeSeperator.isHidden = false
        
        leftFromTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        leftToTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
        if let taskColorName = colorName {
            leftFromTimeLabel.textColor = UIColor(named: taskColorName)
            leftToTimeLabel.textColor = UIColor(named: taskColorName)
        }
    }
    
    func showOnCardTime() {
        hideAllHrs()
        onCardTimeView.isHidden = false
    }
    
    func showTopHrs() {
        hideAllHrs()
        topCardTimeView.isHidden = false
    }
    
    func hideAllHrs() {
        leftCardTimeView.isHidden = true
        topCardTimeView.isHidden = true
        onCardTimeView.isHidden = true
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
}
