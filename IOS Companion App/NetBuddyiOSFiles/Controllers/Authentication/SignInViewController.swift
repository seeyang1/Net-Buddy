//
//  SignInViewController.swift
//  Net Buddy
//
//  Created by Nick Dimitrakas on 11/1/20.
//  Copyright © 2020 Nick Dimitrakas. All rights reserved.
//

import UIKit
import LocalAuthentication

class SignInViewController: BaseViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailPasswordCardView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.tintColor = UIColor(named: "Blue")!
        
        emailTextField.addTarget(self, action: #selector(textFieldGainedFocus), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(textFieldGainedFocus), for: .editingDidBegin)
        
        let boldAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let regularAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let signUpButtonTitle = NSMutableAttributedString()
        signUpButtonTitle.append(NSMutableAttributedString(string: "New to Net Buddy? ", attributes: regularAttributes))
        signUpButtonTitle.append(NSMutableAttributedString(string: "Sign up", attributes: boldAttributes))
        signUpButton.setAttributedTitle(signUpButtonTitle, for: .normal)
        
        emailPasswordCardView.layer.shadowColor = UIColor.black.cgColor
        emailPasswordCardView.layer.shadowRadius = 3
        emailPasswordCardView.layer.shadowOpacity = 0.25
        emailPasswordCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        emailPasswordCardView.layer.masksToBounds = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSpinnerSelector), name: Notification.Name("showSpinner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpinnerSelector), name: Notification.Name("removeSpinner"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            emailTextField.text = email
        }
        
        let context = LAContext()
        context.localizedCancelTitle = "Enter Email/Password"
        
        var error: NSError?
        if !BaseViewController.loggedOut && context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if let email = UserDefaults.standard.string(forKey: "email"), UserDefaults.standard.bool(forKey: "\(email)biometricAuthentication") {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
                        do {
                            let password = try passwordItem.readPassword()
                            DispatchQueue.main.async {
                                FirebaseUtils.signInWith(email, password) { success in
                                    if success {
                                        BaseViewController.loggedInWithEmail = email
                                        DispatchQueue.main.async {
                                            let vc = UIStoryboard(name: "Storyboard", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController
                                            BaseViewController.switchNavigationStack(to: vc)
                                        }
                                    }
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {}
                        }
                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        DispatchQueue.main.async {}
                    }
                }
            }
        }
    }
    
    @objc func textFieldGainedFocus() {
        UIView.animate(withDuration: 0.35) {
            //let y = self.splashImageView.frame.height + 20
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if email.isEmpty || password.isEmpty {
            return
        }
        showSpinner(onView: self.view)
        FirebaseUtils.signInWith(email, password) { success in
            if success {
                UserDefaults.standard.set(email, forKey: "email")
                do {
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
                    // Save the password for the new item.
                    try passwordItem.savePassword(password)
                } catch {}
                BaseViewController.loggedInWithEmail = email
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "User", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController
                    BaseViewController.switchNavigationStack(to: vc)
                    self.removeSpinner()
                }
            } else {
                self.removeSpinner()
                let alert = UIAlertController(title: "Error logging in", message: "Make sure your email and password are correct", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc func removeSpinnerSelector() {
        self.removeSpinner()
    }
    
    @objc func showSpinnerSelector() {
        self.showSpinner(onView: view)
    }
}
