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

    private let onClickTVTitles: [String] = ["Show Task Time on Left", "Show Task Time on Left 2.0", "Show Task Time on Card", "Show Hours on Top", "Show Task Description"]
    private var onClickTVIsOn = [Bool]()
    
    // Always on means that it will be with no click.
    private let alwaysOnTVTitles: [String] = ["Show Task Time on Left", "Show Task Time on Left 2.0", "Show Task Time on Card", "Show Task Time on Top", "Show Task Description"]
    private var alwaysOnTVIsOn = [Bool]()
    
    private let onlyOneCanBeOn = [0, 1, 2, 3]
    
    var delegate: AddNewTaskViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveTaskSettings))
        navigationItem.backButtonTitle = "Back"
        setupTableView()
        
        onClickTVIsOn = DataManager.shared.settingsData.OnClickGlobalSettings
        
        alwaysOnTVIsOn = DataManager.shared.settingsData.alwaysGlobalSettings
    }
    
    private func setupTableView() {
        onClickTV.delegate = self
        onClickTV.dataSource = self
        alwaysOnTV.delegate = self
        alwaysOnTV.dataSource = self
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        onClickTV.register(UINib(resource: R.nib.settingsTableViewCell), forCellReuseIdentifier: R.nib.settingsTableViewCell.identifier)
        alwaysOnTV.register(UINib(resource: R.nib.settingsTableViewCell), forCellReuseIdentifier: R.nib.settingsTableViewCell.identifier)
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
            if let cell = onClickTV.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier) as? SettingsTableViewCell {
                cell.titleLabel.text = onClickTVTitles[indexPath.row]
                if cell.isEnabledSwitch.isEnabled {
                    cell.isEnabledSwitch.isOn = onClickTVIsOn[indexPath.row]
                } else {
                    cell.isEnabledSwitch.isOn = false
                }
                
                return cell
            }
        } else {
            if let cell = alwaysOnTV.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell.identifier) as? SettingsTableViewCell {
                let settingModel = SettingModel(title: alwaysOnTVTitles[indexPath.row], isEnabled: alwaysOnTVIsOn[indexPath.row])
                cell.configure(settingsModel: settingModel)
                return cell
            }
        }
        
        return SettingsTableViewCell()
    }
    
    @objc func saveTaskSettings() {
        guard let carIndex = delegate.cardIndex else { return }
        if carIndex < DataManager.shared.currentDayUnDoneCards.count {
            DataManager.shared.settingsData.OnClickGlobalSettings = onClickTVIsOn
            DataManager.shared.settingsData.alwaysGlobalSettings = alwaysOnTVIsOn
            updateSettings(for: &DataManager.shared.currentDayUnDoneCards, at: carIndex)
        } else {
            let ind = carIndex - DataManager.shared.currentDayUnDoneCards.count
            DataManager.shared.settingsData.OnClickGlobalSettings = onClickTVIsOn
            DataManager.shared.settingsData.alwaysGlobalSettings = alwaysOnTVIsOn
            
            updateSettings(for: &DataManager.shared.currentDayDoneCards, at: ind)
        }
                
        dismiss(animated: true, completion: nil)
    }
    
    func updateSettings(for tableCards: inout [PlanCard], at index: Int) {
        var cardsDisplaySettings = SettingsData()
        if (!(onClickTVIsOn[0] || onClickTVIsOn[1] || onClickTVIsOn[2] || onClickTVIsOn[3])) {
            cardsDisplaySettings.onClickGlobalDisplayCard = .defualt
        } else {
            if onClickTVIsOn[0] {
                cardsDisplaySettings.onClickGlobalDisplayCard = .showHrsLeft
                cardsDisplaySettings.OnClickGlobalSettings[0] = true
            } else if onClickTVIsOn[1]{
                cardsDisplaySettings.onClickGlobalDisplayCard = .showHrsLeft2
                cardsDisplaySettings.OnClickGlobalSettings[1] = true
            } else if onClickTVIsOn[2] {
                    cardsDisplaySettings.onClickGlobalDisplayCard = .showHrsOnCard
                cardsDisplaySettings.OnClickGlobalSettings[2] = true
            } else if onClickTVIsOn[3] {
                cardsDisplaySettings.onClickGlobalDisplayCard = .showHrsTop
                cardsDisplaySettings.OnClickGlobalSettings[3] = true
            }
        }
        
        if onClickTVIsOn[4] {
            cardsDisplaySettings.isOnClickExpandable = true
            cardsDisplaySettings.OnClickGlobalSettings[4] = true
        } else {
            cardsDisplaySettings.isOnClickExpandable = false
            cardsDisplaySettings.OnClickGlobalSettings[4] = true
        }
        
        if (!(alwaysOnTVIsOn[0] || alwaysOnTVIsOn[1] || alwaysOnTVIsOn[2] || alwaysOnTVIsOn[3])) {
            cardsDisplaySettings.alwaysGlobalDisplayCard = .defualt
        } else {
            if alwaysOnTVIsOn[0] {
                cardsDisplaySettings.alwaysGlobalDisplayCard = .showHrsLeft
                cardsDisplaySettings.alwaysGlobalSettings[0] = true
            } else if alwaysOnTVIsOn[1] {
                cardsDisplaySettings.alwaysGlobalDisplayCard = .showHrsLeft2
                cardsDisplaySettings.alwaysGlobalSettings[1] = true
            } else if alwaysOnTVIsOn[2] {
                cardsDisplaySettings.alwaysGlobalDisplayCard = .showHrsOnCard
                cardsDisplaySettings.alwaysGlobalSettings[2] = true
            } else if alwaysOnTVIsOn[3] {
                cardsDisplaySettings.alwaysGlobalDisplayCard = .showHrsTop
                cardsDisplaySettings.alwaysGlobalSettings[3] = true
            }
        }
        
        if alwaysOnTVIsOn[4] {
            cardsDisplaySettings.isAlwaysExpandable = true
            cardsDisplaySettings.alwaysGlobalSettings[4] = true
        } else {
            cardsDisplaySettings.isAlwaysExpandable = false
            cardsDisplaySettings.alwaysGlobalSettings[4] = false
        }
        DispatchQueue.global().async {
            DataManager.shared.settingsData = cardsDisplaySettings
        }
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
