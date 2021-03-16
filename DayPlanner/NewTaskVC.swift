//
//  NewTaskVC.swift
//  DayPlanner
//
//  Created by Usama Fouad on 14/03/2021.
//

import UIKit

class NewTaskVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var TFTaskTitle: SkyFloatingLabelTextField!
    @IBOutlet var category: SkyFloatingLabelTextField!
    @IBOutlet var desc: SkyFloatingLabelTextField!
    
    
    @IBOutlet var color1: UIButton!
    @IBOutlet var color2: UIButton!
    @IBOutlet var color3: UIButton!
    @IBOutlet var color4: UIButton!
    @IBOutlet var color5: UIButton!
    @IBOutlet var color6: UIButton!
    
    var colorButtons = [UIButton]()
    
    var selectedColor: UIColor!
    
    var delegate: ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(insertCard))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        colorButtons = [color1, color2, color3, color4, color5, color6]

    }
    @IBAction func goToTaskSettingClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "GlobalTaskSettings") as? GlobalTaskSettingsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedColor(_ sender: UIButton) {
        selectedColor = sender.backgroundColor
        
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
    
    @objc func insertCard() {
//        let card = PlanCard(taskTitle: TFTaskTitle.text, taskCat: category, taskDesc: desc, taskColor: selectedColor, taskTime: taskTime, taskLenght: taskLen, isDone: false)
//        delegate?.allCards.insert(card, at: 0)
    }
    
}
