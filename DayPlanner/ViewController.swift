//
//  ViewController.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/03/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thuresdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var dayPlansTV: UITableView!
    @IBOutlet var addPlanView: UIView!
    
    var selectedDay: UIButton!
    var daysButtons = [UIButton]()
    var currentDayPlans = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        currentDayPlans = [1]
    }

    @IBAction func dayButtonClicked(_ sender: UIButton) {
        selectedDay = sender
        
        selectedDay.layer.cornerRadius = 25
        selectedDay.backgroundColor = .white
        selectedDay.setTitleColor(.systemIndigo, for: .normal)
        selectedDay.titleLabel?.font = .boldSystemFont(ofSize: 25)
        
        for day in daysButtons {
            if day != selectedDay {
                day.layer.cornerRadius = 0
                day.backgroundColor = .clear
                day.setTitleColor(.white, for: .normal)
                day.titleLabel?.font = .systemFont(ofSize: 20)
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "cell") as? DayPlanTVCell {
            cell.view = addPlanView
            return cell
        }
        return DayPlanTVCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You clicked \(indexPath.row)")
    }
}
