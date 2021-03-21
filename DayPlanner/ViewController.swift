//
//  ViewController.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/03/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        dayPlansTV.dragDelegate = self
        dayPlansTV.dropDelegate = self
        
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        
        for i in 0 ..< 7 {
            daysPlans[i] = Array(repeating: [PlanCard](), count: 2)
        }
        
        currentDayUnDoneCards = daysPlans[selectedDayInd]?[0] ?? []
        currentDayDoneCards = daysPlans[selectedDayInd]?[1] ?? []
        
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
        
        selectedDayInd = daysButtons.firstIndex(of: selectedDay)
        currentDayUnDoneCards = daysPlans[selectedDayInd]?[0] ?? []
        currentDayDoneCards = daysPlans[selectedDayInd]?[1] ?? []
        dayPlansTV.reloadData()
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDayUnDoneCards.count + currentDayDoneCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < currentDayUnDoneCards.count {
            let card = currentDayUnDoneCards[indexPath.row]
            if card.cardDisplay == .expandDesc {
                if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "ExpandDescriptionCell") as? ExpandDescriptionTVCell {
                    cell.cardView.backgroundColor = card.taskColor
                    cell.taskTitleLabel.text = card.taskTitle
                    cell.taskLengthLabel.text = card.taskLenght
                    cell.taskCatLabel.text = card.taskCat
                    cell.fromTimeLabel.text = card.getStringDate()
                    cell.toTimeLabel.text = card.getToTime()
                    cell.taskDescLabel.text = card.taskDesc
                    return cell
                }
            } else {
                if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "PlanCardCell") as? DayPlanCardTVCell {
                    cell.cardView.backgroundColor = card.taskColor
                    cell.cardTitle.text = card.taskTitle
                    cell.cardTtimeLength.text = card.taskLenght
                    cell.cardCategory.text = card.taskCat
                    return cell
                }
            }
        } else if indexPath.row < currentDayUnDoneCards.count + currentDayDoneCards.count {
            let card = currentDayDoneCards[indexPath.row - currentDayUnDoneCards.count]
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "DoneCardCell") as? DoneCardTVCell {
                cell.taskTitle.text = card.taskTitle
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
        guard indexPath.row < currentDayUnDoneCards.count + currentDayDoneCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            if indexPath.row < currentDayUnDoneCards.count {
                self?.editPlan(index: indexPath.row, plan: currentDayUnDoneCards[indexPath.row])
            } else {
                self?.editPlan(index: indexPath.row, plan: currentDayDoneCards[indexPath.row - currentDayUnDoneCards.count])
            }
        }
        editAction.backgroundColor = UIColor(hexString: "#8E8E93FF")
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func editPlan(index: Int, plan: PlanCard) {
        if let vc = storyboard?.instantiateViewController(identifier: "addCardNavBar") as? NewTaskNC {
            if let taskVC = vc.viewControllers.first as? NewTaskVC {
                taskVC.card = plan
                taskVC.cardInd = index
            }
            vc.deleg = self
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < currentDayUnDoneCards.count + currentDayDoneCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        if indexPath.row < currentDayUnDoneCards.count {
            let doneAction = UIContextualAction(style: .normal, title: "Done") {  (_, _, _) in
                currentDayDoneCards.insert(currentDayUnDoneCards[indexPath.row], at: 0)
                currentDayUnDoneCards.remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            doneAction.backgroundColor = UIColor(hexString: "#A9DE91FF")

            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            let unDoneAction = UIContextualAction(style: .normal, title: "UnDone") { (_, _, _) in
                let ind = indexPath.row - currentDayUnDoneCards.count
                currentDayUnDoneCards.insert(currentDayDoneCards[ind], at: 0)
                currentDayDoneCards.remove(at: ind)
                tableView.reloadData()
            }
            unDoneAction.backgroundColor = .red

            return UISwipeActionsConfiguration(actions: [unDoneAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < currentDayUnDoneCards.count + currentDayDoneCards.count {
            
            dayPlansTV.performBatchUpdates({
                let card = currentDayUnDoneCards[indexPath.row]
                if card.cardDisplay != .expandDesc {
                    currentDayUnDoneCards[indexPath.row].cardDisplay = .expandDesc
                } else {
                    currentDayUnDoneCards[indexPath.row].cardDisplay = .defualt
                }
            }, completion: {_ in
                self.dayPlansTV.reloadRows(at: [indexPath], with: .automatic)
            })
        } else {
            if let vc = storyboard?.instantiateViewController(identifier: "addCardNavBar") as? NewTaskNC {
                vc.deleg = self
                present(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row < currentDayUnDoneCards.count else {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = currentDayUnDoneCards[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < currentDayUnDoneCards.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row < currentDayUnDoneCards.count && destinationIndexPath.row < currentDayUnDoneCards.count else {
            tableView.reloadData()
            return
        }
        let mover = currentDayUnDoneCards.remove(at: sourceIndexPath.row)
        currentDayUnDoneCards.insert(mover, at: destinationIndexPath.row)
        daysPlans[selectedDayInd] = [currentDayUnDoneCards, currentDayDoneCards]
        tableView.reloadData()
    }
}
