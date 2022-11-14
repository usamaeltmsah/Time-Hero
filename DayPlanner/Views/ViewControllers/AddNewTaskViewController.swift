//
//  AddNewTaskViewController.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class AddNewTaskViewController: UIViewController, UITextFieldDelegate {
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
    
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var deleteTaskButton: UIButton!
    
    private var selectedColorInd: Int? {
        didSet {
            if let selectedColorInd {
                selectedColorName = ColorsData.shared.colorNames[selectedColorInd]
            }
        }
    }
    private var selectedColorName: String?
    
    private var colorButtons = [UIButton]()
    
    var card: PlanCard?
    var cardIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.black, forKey: "textColor")
        
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
            TFCategory.text = card.taskCategory
            desc.text = card.taskDescription
            selectedColorInd = card.selectedColorIndex
            if let selectedColorInd {
                selectedColor(colorButtons[selectedColorInd])
            }
//            selectedColor = getSelectedColor()
            if let taskTime = card.taskTime {
                datePicker.date = taskTime
            }
            
            if let hr = card.hours {
                TFTaskHours.text = "\(hr)"
            }
            
            if let mn = card.minutes {
                TFTaskMinutes.text = "\(mn)"
            }
        }

    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        let settingsStoryboard = UIStoryboard(name: R.storyboard.cardsSettings.name, bundle: nil)
        if let vc = settingsStoryboard.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedColor(_ sender: UIButton) {
        selectedColorInd = colorButtons.firstIndex(of: sender)
        
        for index in 0..<colorButtons.count {
            if index != selectedColorInd {
                colorButtons[index].layer.shadowRadius = 0
            } else {
                colorButtons[index].layer.shadowColor = UIColor(red: 2, green: 2, blue: 2, alpha: 1).cgColor
                colorButtons[index].layer.shadowOffset = CGSize(width: 0, height: 0)
                colorButtons[index].layer.shadowOpacity = 1
                colorButtons[index].layer.shadowRadius = 3
                colorButtons[index].layer.masksToBounds = false
            }
        }
    }
    
    @objc func savePlan() {
        guard selectedColorName != nil && TFTaskTitle.text != "" && TFCategory.text != "" && (TFTaskHours.text != "" || TFTaskMinutes.text != "") else {
            return
        }
        if card != nil {
            editPlan(index: cardIndex)
        } else {
            insertCard()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func insertCard() {
        let date = datePicker.date
        card = PlanCard()
        card?.taskTitle = TFTaskTitle.text
        card?.taskCategory = TFCategory.text
        card?.taskDescription = desc.text
        card?.taskColorName = selectedColorName
        card?.taskTime = date
        card?.hours = Int(TFTaskHours.text ?? "")
        card?.minutes = Int(TFTaskMinutes.text ?? "")
        card?.selectedColorIndex = selectedColorInd
        if let card {
            self.card?.taskLenght = PlanCard.getTaskLen(for: card)
        }
        if let card {
            DataManager.shared.currentDayUnDoneCards.insert(card, at: 0)
        }
    }
    
    func editPlan(index: Int?) {
        let date = datePicker.date
        card?.taskTitle = TFTaskTitle.text
        card?.taskCategory = TFCategory.text
        card?.taskDescription = desc.text
        card?.taskColorName = selectedColorName
        card?.taskTime = date
        card?.hours = Int(TFTaskHours.text ?? "")
        card?.minutes = Int(TFTaskMinutes.text ?? "")
        card?.selectedColorIndex = selectedColorInd
        if let card {
            self.card?.taskLenght = PlanCard.getTaskLen(for: card)
        }

        if let idx = index, let card {
            if idx < DataManager.shared.currentDayUnDoneCards.count {
                DataManager.shared.currentDayUnDoneCards[idx] = card
            } else {
                DataManager.shared.currentDayDoneCards[idx - DataManager.shared.currentDayUnDoneCards.count] = card
            }
        }
    }
    
    func getSelectedColor() -> UIColor? {
        guard let selectedColorInd else { return nil }
        return colorButtons[selectedColorInd].backgroundColor
    }
    
    
    @IBAction func deleteTaskClicked(_ sender: Any) {
        deletePlan(at: cardIndex)
    }
    
    func deletePlan(at index: Int?) {
        if let idx = index {
            if idx < DataManager.shared.currentDayUnDoneCards.count {
                DataManager.shared.currentDayUnDoneCards.remove(at: idx)
            } else {
                DataManager.shared.currentDayDoneCards.remove(at: idx - DataManager.shared.currentDayUnDoneCards.count)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
