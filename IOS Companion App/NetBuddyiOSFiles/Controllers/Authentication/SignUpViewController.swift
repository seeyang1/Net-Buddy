//
//  SignUpViewController.swift
//  Net Buddy
//
//  Created by Nick Dimitrakas on 3/21/22.
//  Copyright © 2022 Nick Dimitrakas. All rights reserved.
//

import UIKit
import LocalAuthentication

class SignUpViewController: BaseViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseViewController.loggedOut = true
        emailTextField.addTarget(self, action: #selector(beganEditing(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(finishedEditingEmail), for: .editingDidEnd)
        confirmEmailTextField.addTarget(self, action: #selector(beganEditing(_:)), for: .editingDidBegin)
        confirmEmailTextField.addTarget(self, action: #selector(finishedEditingConfirmEmail), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(beganEditing(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(finishedEditingPassword), for: .editingDidEnd)
        confirmPasswordTextField.addTarget(self, action: #selector(beganEditing(_:)), for: .editingDidBegin)
        confirmPasswordTextField.addTarget(self, action: #selector(finishedEditingConfirmPassword), for: .editingDidEnd)
        
        cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.shadowRadius = 3
        cardBackgroundView.layer.shadowOpacity = 0.25
        cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardBackgroundView.layer.masksToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.navigationItem.title = nil
    }
    
    
    @objc func finishedEditingPassword() {
        guard let password = passwordTextField.text else { return }
        if password.count < 8 {
            passwordTextField.textColor = UIColor.red
        } else {
            passwordTextField.textColor = UIColor.label
        }
    }
    
    @objc func finishedEditingConfirmPassword() {
        guard let password = passwordTextField.text else { return }
        guard let confirm = confirmPasswordTextField.text else { return }
        if password != confirm {
            confirmPasswordTextField.textColor = UIColor.red
        } else {
            confirmPasswordTextField.textColor = UIColor.label
        }
    }
    
    @objc func beganEditing(_ sender: UITextField) {
        sender.textColor = UIColor.label
    }
    
    @objc func finishedEditingEmail() {
        guard let email = emailTextField.text else { return }
        if isValidEmail(testStr: email) {
            emailTextField.textColor = UIColor.label
        } else {
            emailTextField.textColor = UIColor.red
        }
    }
    
    @objc func finishedEditingConfirmEmail() {
        guard let email = emailTextField.text else { return }
        guard let confirmEmail = confirmEmailTextField.text else { return }
        if email != confirmEmail {
            confirmEmailTextField.textColor = UIColor.red
        } else {
            confirmEmailTextField.textColor = UIColor.label
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let confirmEmail = confirmEmailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if email.isEmpty || confirmEmail.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return
        }
        
        if !isValidEmail(testStr: email) {
            let alert = UIAlertController(title: "Error", message: "Your email is not valid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if password != confirmPassword {
            let alert = UIAlertController(title: "Error", message: "Your passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if password.count < 8 {
            let alert = UIAlertController(title: "Error", message: "Password must be at least 8 characters long", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        showSpinner(onView: view)
        
        FirebaseUtils.createUserWith(password, email) { success in
            if success {
                let context = LAContext()
                
                var error: NSError?
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    var biometryType = ""
                    switch context.biometryType {
                    case .faceID:
                        biometryType = "FaceID"
                    case .touchID:
                        biometryType = "TouchID"
                    default:
                        biometryType = "Local Authentication"
                    }
                    
                    let alert = UIAlertController(title: "Enable \(biometryType)?", message: "This can be turned on later if you don't want to now.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        UserDefaults.standard.set(true, forKey: "\(email)biometricAuthentication")
                        self.removeSpinner()
                        self.navigationController?.popViewController(animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                        self.removeSpinner()
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                    do {
                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
                        // Save the password for the new item.
                        try passwordItem.savePassword(password)
                        UserDefaults.standard.set(email, forKey: "email")
                    } catch {
                        self.removeSpinner()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Encountered an issue while creating your account, please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.removeSpinner()
            }
        }
    }
}
