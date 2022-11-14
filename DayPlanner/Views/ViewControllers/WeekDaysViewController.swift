//
//  WeekDaysViewController.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/03/2021.
//

import UIKit

class WeekDaysViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thuresdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var dayPlansTV: UITableView!
    @IBOutlet var navBarView: UIView!
    
    private var daysButtons = [UIButton]()
    private var selectedDayButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(navBarView)
        self.dayPlansTV.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        if let dayNum = Date().dayNumberOfWeek() {
            if dayNum - 1 >= 0 {
                DataManager.shared.selectedDayInd = dayNum - 1
            } else {
                DataManager.shared.selectedDayInd = 6
            }
        }
        
        if DataManager.shared.selectedDayInd - 1 >= 0 {
            DataManager.shared.prevSelectedDayIndex = DataManager.shared.selectedDayInd - 1
        } else {
            DataManager.shared.prevSelectedDayIndex = 6
        }
        
        setupTableView()
        
        daysButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thuresdayButton, fridayButton, saturdayButton]
        
        if DataManager.shared.loadData() {
            print("Data Loaded Successfully!")
        } else {
            print("Failed to load data!!")
            for i in 0 ..< 7 {
                DataManager.shared.daysPlans[i] = Array(repeating: [PlanCard](), count: 2)
            }
        }
        
        DataManager.shared.currentDayUnDoneCards = DataManager.shared.daysPlans[DataManager.shared.selectedDayInd]?[0] ?? []
        DataManager.shared.currentDayDoneCards = DataManager.shared.daysPlans[DataManager.shared.selectedDayInd]?[1] ?? []
        
        // Reset the done cards of the previous day in the week
        if DataManager.shared.settingsData.isAppOpenedForDay[DataManager.shared.prevSelectedDayIndex] ?? false {
            DataManager.shared.daysPlans[DataManager.shared.prevSelectedDayIndex]?[0] += DataManager.shared.daysPlans[DataManager.shared.prevSelectedDayIndex]?[1] ?? []
            DataManager.shared.daysPlans[DataManager.shared.prevSelectedDayIndex]?[1].removeAll()
        }
            
        DataManager.shared.settingsData.isAppOpenedForDay[DataManager.shared.selectedDayInd] = true
        DataManager.shared.settingsData.isAppOpenedForDay[DataManager.shared.prevSelectedDayIndex] = false
        
        dayButtonClicked(daysButtons[DataManager.shared.selectedDayInd])
        dayPlansTV.dragInteractionEnabled = true
    }
    
    private func setupTableView() {
        dayPlansTV.delegate = self
        dayPlansTV.dataSource = self
        dayPlansTV.dragDelegate = self
        dayPlansTV.dropDelegate = self
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        dayPlansTV.register(UINib(resource: R.nib.dayPlanCardLeftTopOnCardTableViewCell), forCellReuseIdentifier: R.nib.dayPlanCardLeftTopOnCardTableViewCell.identifier)
        dayPlansTV.register(UINib(resource: R.nib.addTaskTableViewCell), forCellReuseIdentifier: R.nib.addTaskTableViewCell.identifier)
        dayPlansTV.register(UINib(resource: R.nib.doneCardTableViewCell), forCellReuseIdentifier: R.nib.doneCardTableViewCell.identifier)
    }

    @IBAction func dayButtonClicked(_ sender: UIButton) {
        selectedDayButton = sender
        
        selectedDayButton?.layer.cornerRadius = 19
        selectedDayButton?.backgroundColor = .white
        
        selectedDayButton?.setTitleColor(R.color.lightCobaltBlue()!, for: .normal)
        selectedDayButton?.titleLabel?.font = R.font.poppinsBold(size: 18)
        selectedDayButton?.titleLabel?.textAlignment = .center
        
        for dayButton in daysButtons {
            if dayButton != selectedDayButton {
                dayButton.layer.cornerRadius = 0
                dayButton.backgroundColor = .clear
                dayButton.setTitleColor(.white, for: .normal)
                dayButton.titleLabel?.font = R.font.poppinsMedium(size: 18)
            }
        }
        
        guard let selectedDayButton else { return }
        DataManager.shared.selectedDayInd = daysButtons.firstIndex(of: selectedDayButton) ?? 0
        DataManager.shared.currentDayUnDoneCards = DataManager.shared.daysPlans[DataManager.shared.selectedDayInd]?[0] ?? []
        DataManager.shared.currentDayDoneCards = DataManager.shared.daysPlans[DataManager.shared.selectedDayInd]?[1] ?? []
        let range = NSMakeRange(0, self.dayPlansTV.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        if DataManager.shared.selectedDayInd > DataManager.shared.prevSelectedDayIndex {
            self.dayPlansTV.reloadSections(sections as IndexSet, with: .left)
        } else if DataManager.shared.selectedDayInd < DataManager.shared.prevSelectedDayIndex {
            self.dayPlansTV.reloadSections(sections as IndexSet, with: .right)
        }

        DataManager.shared.prevSelectedDayIndex = DataManager.shared.selectedDayInd
    }
    
}

extension WeekDaysViewController : UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.currentDayUnDoneCards.count + DataManager.shared.currentDayDoneCards.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < DataManager.shared.currentDayUnDoneCards.count {
            var card = DataManager.shared.currentDayUnDoneCards[indexPath.row]
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: R.nib.dayPlanCardLeftTopOnCardTableViewCell.identifier) as? DayPlanCardLeftTopOnCardTableViewCell {
                if !(card.taskDescription?.isEmpty ?? false) {
                    card.hasDescription = true
                } else {
                    card.hasDescription = false
                }
                cell.configure(card)
                
                // Apply always on changes
                switch DataManager.shared.settingsData.alwaysGlobalDisplayCard {
                case .showHrsLeft:
                    cell.showLeft1Time()
                case .showHrsLeft2:
                    cell.showLeft2Time(card.taskColorName)
                case .showHrsOnCard:
                    cell.showOnCardTime()
                case .showHrsTop:
                    cell.showTopHrs()
                case .defualt:
                    cell.hideAllHrs()
                default:
                    break
                }
                
                if DataManager.shared.settingsData.isClicked {
                    // Apply on click changes
                    
                    if DataManager.shared.settingsData.isOnClickExpandable ?? false && card.hasDescription ?? false {
                        cell.taskDescLabel.isHidden = false
                        cell.animate()
                    } else if !(DataManager.shared.settingsData.isAlwaysExpandable ?? false) {
                        cell.taskDescLabel.isHidden = true
                    }
                    
                    switch DataManager.shared.settingsData.onClickGlobalDisplayCard {
                    case .showHrsLeft:
                        cell.showLeft1Time()
                    case .showHrsLeft2:
                        cell.showLeft2Time(card.taskColorName)
                    case .showHrsOnCard:
                        cell.showOnCardTime()
                    case .showHrsTop:
                        cell.showTopHrs()
                    default:
                        break
                    }
                } else {
                    
                }
                
                return cell
            }
        } else if indexPath.row < DataManager.shared.currentDayUnDoneCards.count + DataManager.shared.currentDayDoneCards.count {
            let card = DataManager.shared.currentDayDoneCards[indexPath.row - DataManager.shared.currentDayUnDoneCards.count]
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: R.nib.doneCardTableViewCell.identifier) as? DoneCardTableViewCell {
                cell.taskTitle.text = card.taskTitle
                return cell
            }
        } else {
            if let cell = dayPlansTV.dequeueReusableCell(withIdentifier: R.nib.addTaskTableViewCell.identifier) as? AddTaskTableViewCell {
                return cell
            }
        }
        
        return DayPlanCardLeftTopOnCardTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < DataManager.shared.currentDayUnDoneCards.count + DataManager.shared.currentDayDoneCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            if indexPath.row < DataManager.shared.currentDayUnDoneCards.count {
                self?.editPlan(index: indexPath.row, plan: DataManager.shared.currentDayUnDoneCards[indexPath.row])
            } else {
                self?.editPlan(index: indexPath.row, plan: DataManager.shared.currentDayDoneCards[indexPath.row - DataManager.shared.currentDayUnDoneCards.count])
            }
        }
        editAction.backgroundColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func editPlan(index: Int, plan: PlanCard) {
        let addNewCardStoryboard = UIStoryboard(name: R.storyboard.addNewTask.name, bundle: nil)
        if let vc = addNewCardStoryboard.instantiateViewController(identifier: "addCardNavBar") as? NewTaskNavigationController {
            if let taskVC = vc.viewControllers.first as? AddNewTaskViewController {
                taskVC.card = plan
                taskVC.cardIndex = index
            }
            vc.deleg = self
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < DataManager.shared.currentDayUnDoneCards.count + DataManager.shared.currentDayDoneCards.count else {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        if indexPath.row < DataManager.shared.currentDayUnDoneCards.count {
            let doneAction = UIContextualAction(style: .normal, title: "Done") {  (_, _, _) in
                DataManager.shared.currentDayDoneCards.insert(DataManager.shared.currentDayUnDoneCards[indexPath.row], at: 0)
                DataManager.shared.currentDayUnDoneCards.remove(at: indexPath.row)
                UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: DataManager.shared.currentDayUnDoneCards.count, section: 0)) }, completion: {_ in
                    self.dayPlansTV.reloadData()
                })
//                self.dayPlansTV.reloadData()
//                let goal = currentDayUnDoneCards[indexPath.row]
//                self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: currentDayUnDoneCards.count, section: 0))
//                currentDayUnDoneCards.remove(at: indexPath.row)
//                currentDayDoneCards.append(goal)
            }
            
            doneAction.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.8705882353, blue: 0.568627451, alpha: 1)

            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            let unDoneAction = UIContextualAction(style: .normal, title: "UnDone") { (_, _, _) in
                let ind = indexPath.row - DataManager.shared.currentDayUnDoneCards.count
                DataManager.shared.currentDayUnDoneCards.insert(DataManager.shared.currentDayDoneCards[ind], at: 0)
                DataManager.shared.currentDayDoneCards.remove(at: ind)

                UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.dayPlansTV.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0)) }, completion: {_ in
                    self.dayPlansTV.reloadData()
                })            }
            unDoneAction.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.5019607843, blue: 0.537254902, alpha: 1)

            return UISwipeActionsConfiguration(actions: [unDoneAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < DataManager.shared.currentDayUnDoneCards.count {
            for val in DataManager.shared.settingsData.OnClickGlobalSettings {
                if val == true {
//                    UIView.setAnimationsEnabled(false)
//                    UIView.animate(withDuration: 0.3) {
//                        tableView.performBatchUpdates(nil)
//                    }
//                    tableView.beginUpdates()
//                    tableView.reloadRows(at: [indexPath], with: .none)
//                    tableView.endUpdates()
//                    UIView.setAnimationsEnabled(true)
//                    tableView.beginUpdates()
                    DataManager.shared.settingsData.isClicked.toggle()
                    DataManager.shared.saveSettings()
                    tableView.reloadData()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                    tableView.endUpdates()
                    break
                }
            }
            
//            dayPlansTV.performBatchUpdates({
//                currentDayUnDoneCards[indexPath.row].isClicked.toggle()
//            }, completion: {_ in
//                self.dayPlansTV.reloadRows(at: [indexPath], with: .automatic)
//            })
        } else if indexPath.row == DataManager.shared.currentDayUnDoneCards.count + DataManager.shared.currentDayDoneCards.count {
            let addNewCardStoryboard = UIStoryboard(name: R.storyboard.addNewTask.name, bundle: nil)
            if let vc = addNewCardStoryboard.instantiateViewController(identifier: "addCardNavBar") as? NewTaskNavigationController {
                vc.deleg = self
                present(vc, animated: true)
            }
        }
        
    }
    
//    @objc func reloadAllUnDoneCards(in tableView: UITableView) {
//        UIView.animate(withDuration: 0.3) {
//            tableView.performBatchUpdates(nil)
//        }
//        for i in 0 ..< currentDayUnDoneCards.count {
//            let indexPath = IndexPath(row: i, section: 0)
//            tableView.reloadRows(at: [indexPath], with: .none)
//        }
//    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row < DataManager.shared.currentDayUnDoneCards.count else {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = DataManager.shared.currentDayUnDoneCards[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < DataManager.shared.currentDayUnDoneCards.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row < DataManager.shared.currentDayUnDoneCards.count && destinationIndexPath.row < DataManager.shared.currentDayUnDoneCards.count else {
            tableView.reloadData()
            return
        }
        let mover = DataManager.shared.currentDayUnDoneCards.remove(at: sourceIndexPath.row)
        DataManager.shared.currentDayUnDoneCards.insert(mover, at: destinationIndexPath.row)
        DataManager.shared.daysPlans[DataManager.shared.selectedDayInd] = [DataManager.shared.currentDayUnDoneCards, DataManager.shared.currentDayDoneCards]
        tableView.reloadData()
    }
}
