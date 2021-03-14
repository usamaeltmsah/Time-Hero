//
//  DayPlanTVCell.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/03/2021.
//

import UIKit

class DayPlanTVCell: UITableViewCell {

    @IBOutlet var view: UIView!
    var taskTitle: String!
    var taskCat: String!
    var taskDesc: String?
    var taskColor: String!
    var taskTime: String!
    var taskLenght: Int!
    var isDone = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
