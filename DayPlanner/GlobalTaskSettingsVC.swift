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
    
    var onClickTVTitles = [String]()
    var onClickTVIsOn = [Bool]()
    
    var alwaysOnTVTitles = [String]()
    var alwaysOnTVIsOn = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveTaskSettings))
        navigationItem.backButtonTitle = "Back"
        onClickTV.delegate = self
        onClickTV.dataSource = self
        
        alwaysOnTV.delegate = self
        alwaysOnTV.dataSource = self
        
        onClickTVTitles = ["Show Hours on Left", "Show Hours on Card", "Show Hours on Left 2", "Show Hours on Top", "Expand Description", "Apply on All When Click"]
        onClickTVIsOn = [true, false, false, true, true, false]
        
        alwaysOnTVTitles = ["Show Hours on Left", "Cards Expanded", "Show Hours on Card", "Show Hours on Top"]
        alwaysOnTVIsOn = [false, false, true, false]
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
                cell.isEnabled.isOn = onClickTVIsOn[indexPath.row]
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
        
    }
}
