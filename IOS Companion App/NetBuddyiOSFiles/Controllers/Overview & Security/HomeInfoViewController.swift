//
//  HomeInfoViewController.swift
//  NetBuddy
//
//  Created by Nick Dimitrakas on 5/10/22.
//

import Foundation
import UIKit

class HomeInfoViewController: BaseViewController {
    
    // add all IBoutlets for labels here
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var sourceIPLabel: UILabel!
    @IBOutlet weak var countInfoLabel: UILabel!
    @IBOutlet weak var portNumberLabel: UILabel!
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var destinationIPInfoLabel: UILabel!
    @IBOutlet weak var sourceIPInfoLabel: UILabel!
    var keyFromViewController: Int?
    var packetDictionaryFromViewController: [Int: PacketInfo] = [:]
    var protocolsFromViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceIPLabel.text = packetDictionaryFromViewController[keyFromViewController!]!.Source
        countLabel.text = String(packetDictionaryFromViewController[keyFromViewController!]!.Count)
        portNumberLabel.text = String(packetDictionaryFromViewController[keyFromViewController!]!.Port)
        destinationIPInfoLabel.text = packetDictionaryFromViewController[keyFromViewController!]!.Destination
        protocolLabel.text = protocolsFromViewController
        countInfoLabel.text = String(packetDictionaryFromViewController[keyFromViewController!]!.Count)
        sourceIPInfoLabel.text = sourceIPLabel.text
        
    }
}
