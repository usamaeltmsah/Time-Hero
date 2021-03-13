//
//  EXTAlert.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//

import UIKit


extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(OKAction)
        // valide ipad action sheet
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        //------------------------
        self.present(alertController, animated: true, completion: nil)

    }
    
    func AlertInternet (controller : UIViewController) {
        let actionSheet  = UIAlertController(title: "No Internet Connection", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Reload Page", style: .default, handler: { (_) in

            controller.viewDidLoad()
        })
        actionSheet.addAction(alertAction)
        
        let alertAction1 = UIAlertAction(title: "Go Back", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        actionSheet.addAction(alertAction1)
        
        // valide ipad action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        //------------------------
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func AlertServerError (controller : UIViewController) {
        let actionSheet  = UIAlertController(title: "Server Error", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Reload Page", style: .default, handler: { (_) in

            controller.viewDidLoad()
        })
        actionSheet.addAction(alertAction)
        
        let alertAction1 = UIAlertAction(title: "Go Back", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        actionSheet.addAction(alertAction1)
        
        // valide ipad action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        //------------------------
        present(actionSheet, animated: true, completion: nil)
    }
    
}
