//
//  UIViewController.swift
//  walletdoc business
//
//  Created by KUNAL-iMac on 04/02/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func confirmationAlert (title:String, message:String, isDestructive: Bool = true, approveButtonText:String = "Delete", denyButtonText:String = "Cancel", completion:@escaping (_ result:Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: denyButtonText, style: .cancel, handler: { action in
            completion(false)
        }))
        
        if isDestructive{
            alert.addAction(UIAlertAction(title: approveButtonText, style: .destructive, handler: { action in
                completion(true)
            }))
        }else{
            alert.addAction(UIAlertAction(title: approveButtonText, style: .default, handler: { action in
                completion(true)
            }))
        }
    }
    
    func completionAlert (title:String, message:String, completion:@escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion()
        }))
    }
    
    
    func disableUserInteraction() {
        if !UIApplication.shared.isIgnoringInteractionEvents {
            if view.window != nil {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    func showModalProgressView() {
        
        let view = WDLoadingView.getLoadingView(in: self.view)
        
        if view == nil{
            UIApplication.shared.beginIgnoringInteractionEvents()
            WDLoadingView.addLoadingView(to: self.view)
        }
    }
    
    func hideModalProgressView() {
        
        WDLoadingView.hideLoadingView(in: self.view)

        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func showModalProgressView(in containerView: UIView) {
        
        let view = WDLoadingView.getLoadingView(in: containerView)
        
        if view == nil{
            UIApplication.shared.beginIgnoringInteractionEvents()
            WDLoadingView.addLoadingView(to: containerView)
        }
    }
    
    func hideModalProgressView(in containerView: UIView?) {
        WDLoadingView.hideLoadingView(in: containerView)
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
