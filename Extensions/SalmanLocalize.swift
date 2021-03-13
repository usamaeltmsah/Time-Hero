//
//  SalmanLocalize.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//

import UIKit
class SalmanLocalize : NSObject {
    // status = 0 center /// status = 1
    class func UILable ( Key : String , label : UILabel , status : Int ) {
        Shared.shared.lang = UserDefaults.standard.string(forKey: "language")
        if Shared.shared.lang != nil {
            label.text = Key.localizableString(loc: Shared.shared.lang)
            if status == 1 {
                if Shared.shared.lang == "en" {
                    label.textAlignment = .left
                } else {
                    label.textAlignment = .right
                }
            }
        } else {
            Shared.shared.lang = "ar"
            label.text = Key.localizableString(loc: Shared.shared.lang)
            if status == 1 {
                label.textAlignment = .right
            }
        }
    }
    class func UITextFieldPlaceholder ( Key : String , textField : UITextField , status : Int ) {
        Shared.shared.lang = UserDefaults.standard.string(forKey: "language")
        if Shared.shared.lang != nil {
            textField.placeholder = Key.localizableString(loc: Shared.shared.lang)
            if status == 1 {
                if Shared.shared.lang == "en" {
                    textField.textAlignment = .left
                } else {
                    textField.textAlignment = .right
                }
            }
        } else {
            Shared.shared.lang = "ar"
            textField.placeholder = Key.localizableString(loc: Shared.shared.lang)
            if status == 1 {
                textField.textAlignment = .right
            }
        }
    }
    class func UIButton ( Key : String , button : UIButton , status : Int) {
        Shared.shared.lang = UserDefaults.standard.string(forKey: "language")
        if Shared.shared.lang != nil {
            button.setTitle(Key.localizableString(loc: Shared.shared.lang), for: .normal)
            if status == 1 {
                if Shared.shared.lang == "en" {
                    button.contentHorizontalAlignment = .left
                } else {
                    button.contentHorizontalAlignment = .right
                }
            }
        } else {
            Shared.shared.lang = "ar"
            button.setTitle(Key.localizableString(loc: Shared.shared.lang), for: .normal)
            if status == 1 {
                button.contentHorizontalAlignment = .right
            }
        }
    }
    
    
    class func textLocalize (key : String) -> String {
        Shared.shared.lang = UserDefaults.standard.string(forKey: "language")
        let str : String!
        if Shared.shared.lang != nil {
             str = key.localizableString(loc: Shared.shared.lang)
        } else {
            Shared.shared.lang = "ar"
             str = key.localizableString(loc: Shared.shared.lang)
        }
        return str
    }
    
    class func UILabeltextAlignment (label : UILabel) {
        Shared.shared.lang = UserDefaults.standard.string(forKey: "language")
        if Shared.shared.lang != nil {
            if Shared.shared.lang == "en" {
                label.textAlignment = .left
            } else {
                label.textAlignment = .right
            }
        } else {
            Shared.shared.lang = "ar"
            label.textAlignment = .right

        }

    }
}
