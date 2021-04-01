//
//  GlobalTaskSettingsVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class GlobalTaskSettingsVC: UIViewController {
    @IBOutlet var onClickTV: UITableView!
    @IBOutlet var alwaysOnTV: UITableView!
    
    @IBOutlet var onClickSwitchButton: UISwitch!
    @IBOutlet var alwaysOnSwitchButton: UISwitch!
    var onClickTVTitles: [String] = ["Show Task Time on Left", "Show Task Time on Left 2.0", "Show Task Time on Card", "Show Hours on Top", "Show Task Description"]
    var onClickTVIsOn = [Bool]()
    
    // Always on means that it will be with no click.
    var alwaysOnTVTitles: [String] = ["Show Task Time on Left", "Show Task Time on Left 2.0", "Show Task Time on Card", "Show Task Time on Top", "Show Task Description"]
    var alwaysOnTVIsOn = [Bool]()
    
    let onlyOneCanBeOn = [0, 1, 2, 3]
    
    var delegate: NewTaskVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveTaskSettings))
        navigationItem.backButtonTitle = "Back"
        onClickTV.delegate = self
        onClickTV.dataSource = self
        
        alwaysOnTV.delegate = self
        alwaysOnTV.dataSource = self
//        if let onClickSet = delegate.card.onClickSettings {
//            onClickTVIsOn = onClickSet
//        }
        
        onClickTVIsOn = setData.OnClickGlobalSettings
        
//        if let alwaysSet = delegate.card.alwaysOnSettings {
//            alwaysOnTVIsOn = alwaysSet
//        }
        
        alwaysOnTVIsOn = setData.alwaysGlobalSettings
    }
    
    
}

extension GlobalTaskSettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == onClickTV {
            return onClickTVTitles.count
        } else {
            return alwaysOnTVTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == onClickTV {
            if let cell = onClickTV.dequeueReusableCell(withIdentifier: "cell") as? OnClickTVCell {
                cell.title.text = onClickTVTitles[indexPath.row]
                if cell.isEnabled.isEnabled {
                    cell.isEnabled.isOn = onClickTVIsOn[indexPath.row]
                } else {
                    cell.isEnabled.isOn = false
                }
                
                return cell
            }
        } else {
            if let cell = alwaysOnTV.dequeueReusableCell(withIdentifier: "cell") as? AlwaysOnTVCell {
                cell.title.text = alwaysOnTVTitles[indexPath.row]
                cell.isEnabled.isOn = alwaysOnTVIsOn[indexPath.row]
                return cell
            }
        }
        
        return OnClickTVCell()
    }
    
    @objc func saveTaskSettings() {
        if delegate.cardInd < currentDayUnDoneCards.count {
//            currentDayUnDoneCards[delegate.cardInd].onClickSettings = onClickTVIsOn
//            currentDayUnDoneCards[delegate.cardInd].alwaysOnSettings = alwaysOnTVIsOn
            setData.OnClickGlobalSettings = onClickTVIsOn
            setData.alwaysGlobalSettings = alwaysOnTVIsOn
            updateSettings(for: &currentDayUnDoneCards, at: delegate.cardInd)
        } else {
            let ind = delegate.cardInd - currentDayUnDoneCards.count
//            currentDayDoneCards[ind].onClickSettings = onClickTVIsOn
//            currentDayDoneCards[ind].alwaysOnSettings = alwaysOnTVIsOn
            setData.OnClickGlobalSettings = onClickTVIsOn
            setData.alwaysGlobalSettings = alwaysOnTVIsOn
            
            updateSettings(for: &currentDayDoneCards, at: ind)
        }
        
        saveSettings()
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateSettings(for tableCards: inout [PlanCard], at index: Int) {
        if (!(onClickTVIsOn[0] || onClickTVIsOn[1] || onClickTVIsOn[2] || onClickTVIsOn[3])) {
            tableCards[index].OnClickcardDisplay = .defualt
        } else {
            if onClickTVIsOn[0] {
                tableCards[index].OnClickcardDisplay = .showHrsLeft
            } else if onClickTVIsOn[1]{
                tableCards[index].OnClickcardDisplay = .showHrsLeft2
            } else if onClickTVIsOn[2] {
                tableCards[index].OnClickcardDisplay = .showHrsOnCard
            } else if onClickTVIsOn[3] {
                tableCards[index].OnClickcardDisplay = .showHrsTop
            }
        }
        
        if onClickTVIsOn[4] {
            tableCards[index].isOnClickExpandable = true
        } else {
            tableCards[index].isOnClickExpandable = false
        }
        
        if (!(alwaysOnTVIsOn[0] || alwaysOnTVIsOn[1] || alwaysOnTVIsOn[2] || alwaysOnTVIsOn[3])) {
            tableCards[index].AlwaysOncardDisplay = .defualt
        } else {
            if alwaysOnTVIsOn[0] {
                tableCards[index].AlwaysOncardDisplay = .showHrsLeft
            } else if alwaysOnTVIsOn[1] {
                tableCards[index].AlwaysOncardDisplay = .showHrsLeft2
            } else if alwaysOnTVIsOn[2] {
                tableCards[index].AlwaysOncardDisplay = .showHrsOnCard
            } else if alwaysOnTVIsOn[3] {
                tableCards[index].AlwaysOncardDisplay = .showHrsTop
            }
        }
        
        if alwaysOnTVIsOn[4] {
            tableCards[index].isAlwaysExpandable = true
        } else {
            tableCards[index].isAlwaysExpandable = false
        }
        
//        if onClickTVIsOn[5] {
//            setData.isSettingsApplyToAll = true
//            setData.OnClickGlobalSettings = tableCards[index].onClickSettings
//            setData.alwaysGlobalSettings = tableCards[index].alwaysOnSettings

            setData.onClickGlobalDisplayCard = tableCards[index].OnClickcardDisplay
            setData.alwaysGlobalDisplayCard = tableCards[index].AlwaysOncardDisplay
//        } else {
//            setData.isSettingsApplyToAll = false
//
//            setData.onClickGlobalDisplayCard = nil
//            setData.alwaysGlobalDisplayCard = nil
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == onClickTV {
            onClickTVIsOn[indexPath.row].toggle()
            
            if indexPath.row >= 2 && indexPath.row < 5 {
                alwaysOnTVIsOn[indexPath.row] = false
                alwaysOnTV.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            }
            
            if onlyOneCanBeOn.contains(indexPath.row) {
                for i in onlyOneCanBeOn {
                    if i != indexPath.row {
                        onClickTVIsOn[i] = false
                    }
                }
                
                if indexPath.row <= 1 {
                    for i in 0 ... 1 {
                        alwaysOnTVIsOn[i] = false
                        alwaysOnTV.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                    }
                }
            }
            onClickTV.reloadData()
        } else {
            alwaysOnTVIsOn[indexPath.row].toggle()
            
            if indexPath.row >= 2 && indexPath.row < 5 {
                onClickTVIsOn[indexPath.row] = false
                onClickTV.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            }
            
            if onlyOneCanBeOn.contains(indexPath.row) {
                for i in onlyOneCanBeOn {
                    if i != indexPath.row {
                        alwaysOnTVIsOn[i] = false
                    }
                }
                
                if indexPath.row <= 1 {
                    for i in 0 ... 1 {
                        onClickTVIsOn[i] = false
                        onClickTV.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                    }
                }
            }
            alwaysOnTV.reloadData()
        }
    }
}
