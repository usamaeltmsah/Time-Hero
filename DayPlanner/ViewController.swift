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
    
    var selectedDay: UIButton!
    var daysButtons = [UIButton]()
    var currentDayCards = [PlanCard]()
    var currentDayDoneCards = [PlanCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        currentDayCards = [PlanCard(), PlanCard(), PlanCard(), PlanCard(), PlanCard(), PlanCard(), PlanCard()]
        currentDayDoneCards = [PlanCard(), PlanCard()]
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
        return currentDayCards.count + currentDayDoneCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < currentDayCards.count {
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "PlanCardCell") as? DayPlanCardTVCell {
                return cell
            }
        } else if indexPath.row < currentDayCards.count + currentDayDoneCards.count {
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "DoneCardCell") as? DoneCardTVCell {
                return cell
            }
        } else {
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "newTaskCardCell") as? AddTaskTVCell {
                return cell
            }
        }
        
        return DayPlanCardTVCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
//            self?.editPlan(at: indexPath.row)
        }
        editAction.backgroundColor = UIColor(hexString: "#8E8E93FF")

        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (_, _, _) in
//            self?.savePlan(at: indexPath.row)
        }
        
        doneAction.backgroundColor = UIColor(hexString: "#A9DE91FF")

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "addCard") as? UINavigationController {
            present(vc, animated: true)
        }
    }
}
