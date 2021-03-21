//
//  NewTaskVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class NewTaskVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var TFTaskTitle: SkyFloatingLabelTextField!
    @IBOutlet var TFCategory: SkyFloatingLabelTextField!
    @IBOutlet var desc: SkyFloatingLabelTextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var TFTaskHours: UITextField!
    @IBOutlet var TFTaskMinutes: UITextField!
    
    @IBOutlet var color1: UIButton!
    @IBOutlet var color2: UIButton!
    @IBOutlet var color3: UIButton!
    @IBOutlet var color4: UIButton!
    @IBOutlet var color5: UIButton!
    @IBOutlet var color6: UIButton!
    
    var colorButtons = [UIButton]()
    var selectedColorInd: Int!
    var selectedColor: UIColor!
    
    var card: PlanCard!
    var cardInd: Int!
    
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var deleteTaskButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(savePlan))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        colorButtons = [color1, color2, color3, color4, color5, color6]
        
        selectedColor(color1)
        if let card = card {
            settingButton.isHidden = false
            deleteTaskButton.isHidden = false
            TFTaskTitle.text = card.taskTitle
            TFCategory.text = card.taskCat
            desc.text = card.taskDesc
            selectedColorInd = card.selectedColorInd
            selectedColor(colorButtons[selectedColorInd])
            selectedColor = getSelectedColor()
            datePicker.date = card.taskTime
            
            if let hr = card.hours {
                TFTaskHours.text = "\(hr)"
            }
            
            if let mn = card.minutes {
                TFTaskMinutes.text = "\(mn)"
            }
        }

    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedColor(_ sender: UIButton) {
        selectedColor = sender.backgroundColor
        selectedColorInd = colorButtons.firstIndex(of: sender)
        
        for color in colorButtons {
            if color.backgroundColor != selectedColor {
                color.layer.shadowRadius = 0
            } else {
                color.layer.shadowColor = UIColor(red: 2, green: 2, blue: 2, alpha: 1).cgColor
                color.layer.shadowOffset = CGSize(width: 0, height: 0)
                color.layer.shadowOpacity = 1
                color.layer.shadowRadius = 3
                color.layer.masksToBounds = false
            }
        }
    }
    
    @objc func savePlan() {
        guard selectedColor != nil && TFTaskTitle.text != "" && TFCategory.text != "" && (TFTaskHours.text != "" || TFTaskMinutes.text != "") else {
            return
        }
        if card != nil {
            editPlan(index: cardInd)
        } else {
            insertCard()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func insertCard() {
        let date = datePicker.date
        card = PlanCard()
        card.taskTitle = TFTaskTitle.text
        card.taskCat = TFCategory.text
        card.taskDesc = desc.text
        card.taskColor = selectedColor
        card.taskTime = date
        card.hours = Int(TFTaskHours.text ?? "")
        card.minutes = Int(TFTaskMinutes.text ?? "")
        card.taskColor = selectedColor
        card.selectedColorInd = selectedColorInd
        card.taskColorButton = colorButtons[selectedColorInd]
        
        card.onClickSettings = [false, false, false, true, true, false]
        card.alwaysOnSettings = [false, false, false, true, false]
        
        card.taskLenght = card.getTaskLen()
        currentDayUnDoneCards.insert(card, at: 0)
    }
    
    func editPlan(index: Int?) {
        let date = datePicker.date
        card.taskTitle = TFTaskTitle.text
        card.taskCat = TFCategory.text
        card.taskDesc = desc.text
        card.taskColor = selectedColor
        card.taskTime = date
        card.hours = Int(TFTaskHours.text ?? "")
        card.minutes = Int(TFTaskMinutes.text ?? "")
        card.taskLenght = card.getTaskLen()
        card.selectedColorInd = selectedColorInd
        card.taskColorButton = colorButtons[selectedColorInd]
        if let idx = index {
            if idx < currentDayUnDoneCards.count {
                currentDayUnDoneCards[idx] = card
            } else {
                currentDayDoneCards[idx - currentDayUnDoneCards.count] = card
            }
        }
    }
    
    func getSelectedColor() -> UIColor! {
        return colorButtons[selectedColorInd].backgroundColor
    }
    
    
    @IBAction func deleteTaskClicked(_ sender: Any) {
        deletePlan(at: cardInd)
    }
    
    func deletePlan(at index: Int?) {
        if let idx = index {
            if idx < currentDayUnDoneCards.count {
                currentDayUnDoneCards.remove(at: idx)
            } else {
                currentDayDoneCards.remove(at: idx - currentDayUnDoneCards.count)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
