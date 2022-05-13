//
//  HomeViewController.swift
//  NetBuddy
//
//  Created by Nick Dimitrakas on 4/12/22.
//  Copyright © 2022 Nick Dimitrakas. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeSegmentedControl: UISegmentedControl!
    var packetDictionary: [Int: PacketInfo] = getData()
    var filteredPacketDictionary: [Int: PacketInfo] = [:]
    var filteredKeySortingArray: [Int] = []
    var portNumberKeyArray: [Int] = []
    var keyForViewController: Int = 0
    let commonPortNumbers: [Int] = [20,21,22,23,25,53,69,79,80,110,119,161,162,443]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        filterPackets(homeSegmentedControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.navigationItem.title = "Home"
    }
    
    func sortKeys(dict: [Int: PacketInfo]) -> [Int] {
        print("\n\n\n\n",portNumberKeyArray)
        var arr: [Int] = []
        for (k,_) in dict {
            arr.append(k)
        }
        arr = arr.sorted { a, b in
            let aInPortKeyArr: Bool = portNumberKeyArray.contains(a)
            let bInPortKeyArr: Bool = portNumberKeyArray.contains(b)
            if aInPortKeyArr && bInPortKeyArr {
                return a < b
            } else if aInPortKeyArr {
                return true
            } else if bInPortKeyArr {
                return false
            } else {
                return a < b
            }
        }
        return arr
    }
    
    func checkForPortScan(dict: [Int: PacketInfo]) {
        portNumberKeyArray = []
        for (k,_) in dict {
            for i in commonPortNumbers {
                if dict[k]!.Port == i {
                    // put the keys into the portNumberKeyArray
                    portNumberKeyArray.append(k)
                }
            }
        }
        if (portNumberKeyArray.count >= 2) {
            for i in 0..<portNumberKeyArray.count-1 {
                for j in i..<portNumberKeyArray.count-1 {
                    if i == j {
                        continue
                    } else if (dict[portNumberKeyArray[i]]!.Source == dict[portNumberKeyArray[j]]!.Source && dict[portNumberKeyArray[i]]!.Destination == dict[portNumberKeyArray[j]]!.Destination && dict[portNumberKeyArray[i]]!.`Protocol`.data == dict[portNumberKeyArray[j]]!.`Protocol`.data) {
                        let vc = self.tabBarController?.viewControllers![1] as! SettingsViewController
                        vc.dictionaryFromViewController = filteredPacketDictionary
                        vc.historyFromViewController = dict[portNumberKeyArray[i]]!.Source
                        let alert = UIAlertController(title: "Malicious Activity", message: "High probability you are being port scanned from \(dict[portNumberKeyArray[i]]!.Source) IP address", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                            print(action)
                        }
                        alert.addAction(okayAction)
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func filterPackets(_ sender: UISegmentedControl) {
        filteredPacketDictionary = [:]
        var firstLetterAsciiCode: Int
        if homeSegmentedControl.titleForSegment(at: homeSegmentedControl.selectedSegmentIndex) == "UDP" {
            firstLetterAsciiCode = 85
        } else {
            firstLetterAsciiCode = 116
        }
        for (k,_) in packetDictionary {
            if packetDictionary[k]!.`Protocol`.data[0] == firstLetterAsciiCode {
                filteredPacketDictionary[k] = packetDictionary[k]
            }
        }
        filteredKeySortingArray = sortKeys(dict: filteredPacketDictionary)
        checkForPortScan(dict: filteredPacketDictionary)
        filteredKeySortingArray = sortKeys(dict: filteredPacketDictionary)
        self.homeTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let newProtocolVar = homeSegmentedControl.titleForSegment(at: homeSegmentedControl.selectedSegmentIndex)
        let newKeyVar = keyForViewController
        let newDictionary = filteredPacketDictionary
        let destinationVC = segue.destination as! HomeInfoViewController
        destinationVC.keyFromViewController = newKeyVar
        destinationVC.packetDictionaryFromViewController = newDictionary
        destinationVC.protocolsFromViewController = newProtocolVar
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPacketDictionary.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = filteredKeySortingArray[indexPath.row]
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        cell.sourceIPLabel.text = filteredPacketDictionary[key]!.Source
        cell.countLabel.text = String(filteredPacketDictionary[key]!.Count)
        
        
        cell.cellView.layer.shadowColor = UIColor.black.cgColor
        cell.cellView.layer.shadowRadius = 3
        cell.cellView.layer.shadowOpacity = 0.25
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.cellView.layer.masksToBounds = false
        
        if portNumberKeyArray.contains(key) {
            cell.cellView.backgroundColor = UIColor.red
            cell.sourceIPLabel.textColor = UIColor.white
            cell.countLabel.textColor = UIColor.white
        } else {
            cell.cellView.backgroundColor = UIColor.white
            cell.sourceIPLabel.textColor = UIColor.black
            cell.countLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        keyForViewController = filteredKeySortingArray[indexPath.row]
        homeTableView.deselectRow(at: indexPath, animated: true)
        let segue = UIStoryboardSegue(identifier: "homeToHomeInfoSegue", source: self, destination: HomeInfoViewController())
        self.prepare(for: segue, sender: self)
        self.performSegue(withIdentifier: "homeToHomeInfoSegue", sender: self)
    }
    
}

