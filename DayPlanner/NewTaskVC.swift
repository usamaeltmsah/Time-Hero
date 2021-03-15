//
//  NewTaskVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class NewTaskVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var TFTaskTitle: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelClicked(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
