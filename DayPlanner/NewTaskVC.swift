//
//  NewTaskVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class NewTaskVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let dateTypes = ["Date Type","M", "H", "D"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateTypes.count
    }
    

    @IBOutlet var TFDateType: SkyFloatingLabelTextFieldWithIcon!
    
    var pickerViewUserType = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        
        TFDateType.inputView = pickerViewUserType
        
        pickerViewUserType.dataSource = self
        pickerViewUserType.delegate   = self
    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelClicked(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewUserType {
            
            if row == 0 {
                pickerView.selectRow(1, inComponent: component, animated: false)
            } else {
                TFDateType.text = dateTypes[row]
            }
            
            switch dateTypes[row] {
            case "M":
                break
            case "H":
                break
            case "D":
                break
            default:
                break
            }
        }
    }
    
}
