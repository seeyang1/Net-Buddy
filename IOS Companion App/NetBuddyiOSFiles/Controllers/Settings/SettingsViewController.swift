//
//  SettingsViewController.swift
//  NetBuddy
//
//  Created by Nick Dimitrakas on 4/12/22.
//  Copyright © 2022 Nick Dimitrakas. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    var historyFromViewController: String = ""
    var dictionaryFromViewController: [Int: PacketInfo] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateText()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.title = "Settings"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func updateText() {
        //let today = Date()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "MM/dd/YY @ HH:mm"
        historyLabel.text = (historyLabel.text ?? "") + "High probability of port scanning from IP \(historyFromViewController)\n"
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignInViewController", sender: self)
    }
}
