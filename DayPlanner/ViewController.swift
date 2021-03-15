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
    
    var allCards = [PlanCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        dayPlansTV.dragDelegate = self
        dayPlansTV.dropDelegate = self
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        currentDayCards = [PlanCard(taskTitle: "New Task", taskCat: "Cdsc", taskDesc: "cdsvfdsv", taskColor: UIColor(hexString: "#F2AC80FF"), taskTime: "", taskLenght: "30M", isDone: false), PlanCard(taskTitle: "Task 2", taskCat: "Cat 2", taskDesc: "Desc of task 2", taskColor: UIColor(hexString: "#F28089FF"), taskTime: "", taskLenght: "3H", isDone: false), PlanCard(taskTitle: "Task 3", taskCat: "Cat 3", taskDesc: "Desc of task 3", taskColor: UIColor(hexString: "#80A3F2FF"), taskTime: "", taskLenght: "1H 30M", isDone: false)]
        currentDayDoneCards = [PlanCard(), PlanCard()]
        
        allCards = currentDayCards + currentDayDoneCards
        
        dayPlansTV.dragInteractionEnabled = true
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

extension ViewController : UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < currentDayCards.count {
            let card = currentDayCards[indexPath.row]
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "PlanCardCell") as? DayPlanCardTVCell {
                cell.cardView.backgroundColor = card.taskColor
                cell.cardTitle.text = card.taskTitle
                cell.cardTtimeLength.text = card.taskLenght
                cell.cardCategory.text = card.taskCat
                return cell
            }
        } else if indexPath.row < allCards.count {
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
        guard indexPath.row < allCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
//            self?.editPlan(at: indexPath.row)
        }
        editAction.backgroundColor = UIColor(hexString: "#8E8E93FF")
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < allCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        if indexPath.row < currentDayCards.count {
            let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (_, _, _) in
    //            self?.savePlan(at: indexPath.row)
            }
            
            doneAction.backgroundColor = UIColor(hexString: "#A9DE91FF")

            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            let unDoneAction = UIContextualAction(style: .normal, title: "UnDone") { [weak self] (_, _, _) in
    //            self?.savePlan(at: indexPath.row)
            }
            
            unDoneAction.backgroundColor = .red

            return UISwipeActionsConfiguration(actions: [unDoneAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == allCards.count {
            if let vc = storyboard?.instantiateViewController(identifier: "addCard") as? UINavigationController {
                present(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row < currentDayCards.count else {
            return []
        }
        print(3)
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = currentDayCards[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < currentDayCards.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row < currentDayCards.count && destinationIndexPath.row < currentDayCards.count else {
            tableView.reloadData()
            return
        }
        currentDayCards.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
