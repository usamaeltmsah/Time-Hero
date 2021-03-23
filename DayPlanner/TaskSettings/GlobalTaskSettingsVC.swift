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
    var onClickTVTitles: [String] = ["Show Task Time on Left", "Show Task Time on Left 2.0", "Show Task Time on Card", "Show Hours on Top", "Show Task Description", "Apply on All Cards on Click"]
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
        if let onClickSet = delegate.card.onClickSettings {
            onClickTVIsOn = onClickSet
        }
        
        if let alwaysSet = delegate.card.alwaysOnSettings {
            alwaysOnTVIsOn = alwaysSet
        }
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
        currentDayUnDoneCards[delegate.cardInd].onClickSettings = onClickTVIsOn
        currentDayUnDoneCards[delegate.cardInd].alwaysOnSettings = alwaysOnTVIsOn
                
        if onClickTVIsOn[0] {
            delegate.card.cardDisplay = .showHrsLeft
        } else if onClickTVIsOn[1]{
            delegate.card.cardDisplay = .showHrsLeft2
        } else if onClickTVIsOn[2] {
            delegate.card.cardDisplay = .showHrsCard
        } else if onClickTVIsOn[3] {
            delegate.card.cardDisplay = .showHrsTop
        }
        if onClickTVIsOn[4] {
            delegate.card.cardDisplay = .expandDesc
        }
        if onClickTVIsOn[5] {
            isSettingsApplyToAll = true
        }
        
        if alwaysOnTVIsOn[0] {
            delegate.card.cardDisplay = .showHrsLeft
        } else if alwaysOnTVIsOn[1]{
            delegate.card.cardDisplay = .showHrsLeft2
        } else if alwaysOnTVIsOn[2] {
            delegate.card.cardDisplay = .showHrsCard
        } else if alwaysOnTVIsOn[3] {
            delegate.card.cardDisplay = .showHrsTop
        }
        if alwaysOnTVIsOn[4] {
            delegate.card.cardDisplay = .expandDesc
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == onClickTV {
            onClickTVIsOn[indexPath.row].toggle()
            
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
