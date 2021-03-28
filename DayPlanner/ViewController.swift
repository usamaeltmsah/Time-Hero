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
    
    var prevSelectedDayInd: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dayPlansTV.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)

        
        if let dayNum = Date().dayNumberOfWeek() {
            if dayNum - 1 >= 0 {
                selectedDayInd = dayNum - 1
            } else {
                selectedDayInd = 6
            }
        }
        
        prevSelectedDayInd = selectedDayInd
        
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        dayPlansTV.dragDelegate = self
        dayPlansTV.dropDelegate = self
        
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        
        if loadData() {
            print("Data Loaded Successfully!")
        } else {
            print("Failed to load data!!")
            for i in 0 ..< 7 {
                daysPlans[i] = Array(repeating: [PlanCard](), count: 2)
            }
        }
        
        currentDayUnDoneCards = daysPlans[selectedDayInd]?[0] ?? []
        currentDayDoneCards = daysPlans[selectedDayInd]?[1] ?? []
        
        for i in 0 ..< 7 {
            if i == selectedDayInd {
                continue
            }
            
            daysPlans[i]?[0] += daysPlans[i]?[1] ?? []
            daysPlans[i]?[1].removeAll()
        }
        
        dayButtonClicked(daysButtons[selectedDayInd])
        dayPlansTV.dragInteractionEnabled = true
    }

    @IBAction func dayButtonClicked(_ sender: UIButton) {
        selectedDay = sender
        
        selectedDay.layer.cornerRadius = 17.5
        selectedDay.backgroundColor = .white
        
        selectedDay.setTitleColor(#colorLiteral(red: 0.4509803922, green: 0.5607843137, blue: 0.937254902, alpha: 1), for: .normal)
        selectedDay.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
        selectedDay.titleLabel?.textAlignment = .center
        
        for day in daysButtons {
            if day != selectedDay {
                day.layer.cornerRadius = 0
                day.backgroundColor = .clear
                day.setTitleColor(.white, for: .normal)
                day.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18)
            }
        }
        
        selectedDayInd = daysButtons.firstIndex(of: selectedDay)
        currentDayUnDoneCards = daysPlans[selectedDayInd]?[0] ?? []
        currentDayDoneCards = daysPlans[selectedDayInd]?[1] ?? []
        let range = NSMakeRange(0, self.dayPlansTV.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        if selectedDayInd > prevSelectedDayInd {
            self.dayPlansTV.reloadSections(sections as IndexSet, with: .left)
        } else if selectedDayInd < prevSelectedDayInd {
            self.dayPlansTV.reloadSections(sections as IndexSet, with: .right)
        }

        prevSelectedDayInd = selectedDayInd
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDayUnDoneCards.count + currentDayDoneCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < currentDayUnDoneCards.count {
            if isSettingsApplyToAll {
                currentDayUnDoneCards[indexPath.row].onClickSettings = OnClickGlobalSettings
                currentDayUnDoneCards[indexPath.row].alwaysOnSettings = alwaysGlobalSettings
                
                currentDayUnDoneCards[indexPath.row].OnClickcardDisplay = onClickGlobalDisplayCard
                currentDayUnDoneCards[indexPath.row].AlwaysOncardDisplay = alwaysGlobalDisplayCard
                
                currentDayUnDoneCards[indexPath.row].isOnClickExpandable = currentDayUnDoneCards[indexPath.row].onClickSettings[4]
                currentDayUnDoneCards[indexPath.row].isAlwaysExpandable = currentDayUnDoneCards[indexPath.row].alwaysOnSettings[4]
            }
            var card = currentDayUnDoneCards[indexPath.row]
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: "DayPlanCardWithLeftTVCell") as? DayPlanCardWithLeftTopOnCardTVCell {
                
                cell.cardView.backgroundColor = card.taskColor
                cell.taskTitleLabel.text = card.taskTitle
                cell.taskLengthLabel.text = card.taskLenght
                cell.taskCatLabel.text = card.taskCat
                
                if !(card.taskDesc?.isEmpty ?? false) {
                    card.hasDescription = true
                    cell.taskDescLabel.text = card.taskDesc
                } else {
                    card.hasDescription = false
                }
                
                cell.leftFromTimeLabel.text = card.getFromTime()
                cell.leftToTimeLabel.text = card.getToTime()
                                
                cell.leftFromTimeLabel.text = card.getFromTime()
                cell.leftToTimeLabel.text = card.getToTime()
                
                cell.onCardFromTimeLabel.text = card.getFromTime()
                cell.onCardToTimeLabel.text = card.getToTime()
                
                cell.topFromTimeLabel.text = card.getFromTime()
                cell.topToTimeLabel.text = card.getToTime()
                cell.topFromTimeLabel.textColor = card.taskColor
                cell.topFromTimeSeperator.textColor = card.taskColor
                cell.topToTimeLabel.textColor = card.taskColor
                
                cell.left2TimeSeperator.image = UIImage(named: arrowsImages[card.selectedColorInd])
                
                if card.isAlwaysExpandable && card.hasDescription {
                    cell.taskDescLabel.isHidden = false
                } else {
                    cell.taskDescLabel.isHidden = true
                }
                
                // Apply always on changes
                switch card.AlwaysOncardDisplay {
                case .showHrsLeft:
                    cell.leftCardTimeView.isHidden = false
                    cell.onCardTimeView.isHidden = true
                    cell.topCardTimeView.isHidden = true
                    cell.left1TimeSeperator.isHidden = false
                    cell.left2TimeSeperator.isHidden = true
                    
                    cell.leftFromTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
                    cell.leftToTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
                    
                    cell.leftFromTimeLabel.textColor = .black
                    cell.left1TimeSeperator.textColor = .black
                    cell.leftToTimeLabel.textColor = .black
                case .showHrsLeft2:
                    cell.leftCardTimeView.isHidden = false
                    cell.topCardTimeView.isHidden = true
                    cell.onCardTimeView.isHidden = true
                    cell.left1TimeSeperator.isHidden = true
                    cell.left2TimeSeperator.isHidden = false
                    
                    cell.leftFromTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
                    cell.leftToTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
                    
                    cell.leftFromTimeLabel.textColor = card.taskColor
                    cell.leftToTimeLabel.textColor = card.taskColor
                case .showHrsOnCard:
                    cell.leftCardTimeView.isHidden = true
                    cell.topCardTimeView.isHidden = true
                    cell.onCardTimeView.isHidden = false
                case .showHrsTop:
                    cell.leftCardTimeView.isHidden = true
                    cell.topCardTimeView.isHidden = false
                    cell.onCardTimeView.isHidden = true
                case .defualt:
                    cell.leftCardTimeView.isHidden = true
                    cell.topCardTimeView.isHidden = true
                    cell.onCardTimeView.isHidden = true
                default:
                    break
                }
                
                if card.isClicked {
                    // Apply on click changes
                    
                    if card.isOnClickExpandable && card.hasDescription {
                        cell.taskDescLabel.isHidden = false
                        cell.animate()
                    } else if !card.isAlwaysExpandable {
                        cell.taskDescLabel.isHidden = true
                    }
                    
                    switch card.OnClickcardDisplay {
                    case .showHrsLeft:
                        cell.leftFromTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
                        cell.leftToTimeLabel.font = UIFont(name: "Poppins-Medium", size: 12)
                        cell.leftCardTimeView.isHidden = false
                        if card.AlwaysOncardDisplay != .showHrsOnCard {
                            cell.onCardTimeView.isHidden = true
                        } else {
                            cell.onCardTimeView.isHidden = false
                        }
                        if card.AlwaysOncardDisplay != .showHrsTop {
                            cell.topCardTimeView.isHidden = true
                        } else {
                            cell.topCardTimeView.isHidden = false
                        }
                        
                        cell.left1TimeSeperator.isHidden = false
                        
                        cell.left2TimeSeperator.isHidden = true
                        
                        cell.leftFromTimeLabel.textColor = .black
                        cell.left1TimeSeperator.textColor = .black
                        cell.leftToTimeLabel.textColor = .black
                    case .showHrsLeft2:
                        cell.leftFromTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
                        cell.leftToTimeLabel.font = UIFont(name: "Poppins-Bold", size: 14)
                        cell.leftCardTimeView.isHidden = false
                        if card.AlwaysOncardDisplay != .showHrsOnCard {
                            cell.onCardTimeView.isHidden = true
                        } else {
                            cell.onCardTimeView.isHidden = false
                        }
                        if card.AlwaysOncardDisplay != .showHrsTop {
                            cell.topCardTimeView.isHidden = true
                        } else {
                            cell.topCardTimeView.isHidden = false
                        }
                        cell.left1TimeSeperator.isHidden = true
                        cell.left2TimeSeperator.isHidden = false
                        
                        cell.leftFromTimeLabel.textColor = card.taskColor
                        cell.leftToTimeLabel.textColor = card.taskColor
                    case .showHrsOnCard:
                        cell.onCardTimeView.isHidden = false
                        
                        if card.AlwaysOncardDisplay != .showHrsLeft && card.AlwaysOncardDisplay != .showHrsLeft2 {
                            cell.leftCardTimeView.isHidden = true
                        } else {
                            cell.leftCardTimeView.isHidden = false
                        }
                        if card.AlwaysOncardDisplay != .showHrsTop {
                            cell.topCardTimeView.isHidden = true
                        } else {
                            cell.topCardTimeView.isHidden = false
                        }
                    case .showHrsTop:
                        cell.topCardTimeView.isHidden = false
                        if card.AlwaysOncardDisplay != .showHrsLeft && card.AlwaysOncardDisplay != .showHrsLeft2 {
                            cell.leftCardTimeView.isHidden = true
                        } else {
                            cell.leftCardTimeView.isHidden = false
                        }
                        if card.AlwaysOncardDisplay != .showHrsOnCard {
                            cell.onCardTimeView.isHidden = true
                        } else {
                            cell.onCardTimeView.isHidden = false
                        }
                    default:
                        break
                    }
                } else {
                    
                }
                
                return cell
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
        
        return DayPlanCardWithLeftTopOnCardTVCell()
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
                UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: currentDayUnDoneCards.count, section: 0)) }, completion: {_ in
                    self.dayPlansTV.reloadData()
                })
//                self.dayPlansTV.reloadData()
//                let goal = currentDayUnDoneCards[indexPath.row]
//                self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: currentDayUnDoneCards.count, section: 0))
//                currentDayUnDoneCards.remove(at: indexPath.row)
//                currentDayDoneCards.append(goal)
            }
            
            doneAction.backgroundColor = UIColor(hexString: "#A9DE91FF")

            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            let unDoneAction = UIContextualAction(style: .normal, title: "UnDone") { (_, _, _) in
                let ind = indexPath.row - currentDayUnDoneCards.count
                currentDayUnDoneCards.insert(currentDayDoneCards[ind], at: 0)
                currentDayDoneCards.remove(at: ind)

                UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0)) }, completion: {_ in
                    self.dayPlansTV.reloadData()
                })            }
            unDoneAction.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.5019607843, blue: 0.537254902, alpha: 1)

            return UISwipeActionsConfiguration(actions: [unDoneAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < currentDayUnDoneCards.count {
            tableView.beginUpdates()
            currentDayUnDoneCards[indexPath.row].isClicked.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
//            dayPlansTV.performBatchUpdates({
//                currentDayUnDoneCards[indexPath.row].isClicked.toggle()
//            }, completion: {_ in
//                self.dayPlansTV.reloadRows(at: [indexPath], with: .automatic)
//            })
        } else if indexPath.row == currentDayUnDoneCards.count + currentDayDoneCards.count {
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
