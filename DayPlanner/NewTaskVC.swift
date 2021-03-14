//
//  NewTaskVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class NewTaskVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
