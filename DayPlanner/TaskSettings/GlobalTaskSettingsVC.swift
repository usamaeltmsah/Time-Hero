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
    
    var onClickTVTitlesIsOn = [String:Bool]()
//    var onClickTVIsOn = [Bool]()
    
    var alwaysOnTVTitlesIsOn = [String:Bool]()
//    var alwaysOnTVIsOn = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveTaskSettings))
        navigationItem.backButtonTitle = "Back"
        onClickTV.delegate = self
        onClickTV.dataSource = self
        
        alwaysOnTV.delegate = self
        alwaysOnTV.dataSource = self
        
        onClickTVTitlesIsOn = ["Show Hours on Left":true, "Show Hours on Card":false, "Show Hours on Left 2":false, "Show Hours on Top":true, "Expand Description": false, "Apply on All When Click":true]
//        onClickTVIsOn = [true, false, false, true, true, false]
        
        alwaysOnTVTitlesIsOn = ["Show Hours on Left":false, "Cards Expanded":false, "Show Hours on Card":true, "Show Hours on Top":false]
//        alwaysOnTVIsOn = [false, false, true, false]
    }
    
    
}

extension GlobalTaskSettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == onClickTV {
            return onClickTVTitlesIsOn.count
        } else {
            return alwaysOnTVTitlesIsOn.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == onClickTV {
            if let cell = onClickTV.dequeueReusableCell(withIdentifier: "cell") as? OnClickTVCell {
                cell.title.text = Array(onClickTVTitlesIsOn.keys)[indexPath.row]
                cell.isEnabled.isOn = Array(onClickTVTitlesIsOn.values)[indexPath.row]
                return cell
            }
        } else {
            if let cell = alwaysOnTV.dequeueReusableCell(withIdentifier: "cell") as? AlwaysOnTVCell {
                cell.title.text = Array(alwaysOnTVTitlesIsOn.keys)[indexPath.row]
                cell.isEnabled.isOn = Array(alwaysOnTVTitlesIsOn.values)[indexPath.row]
                return cell
            }
        }
        
        return OnClickTVCell()
    }
    
    @objc func saveTaskSettings() {
        
    }
}
