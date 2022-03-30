//
//  BaseViewController.swift
//  Net Buddy
//
//  Created by Nick Dimitrakas on 3/21/22.
//  Copyright © 2022 Nick Dimitrakas. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    static var loggedInWithEmail: String?
    static var loggedOut = false
    var vSpinner: UIView?
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.25)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func switchNavigationStack(to navigationController: UINavigationController) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navigationController
        })
    }
}
