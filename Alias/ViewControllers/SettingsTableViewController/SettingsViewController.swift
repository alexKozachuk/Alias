//
//  SettingsViewController.swift
//  Alias
//
//  Created by Sasha on 22/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var roundSegmentControl: UISegmentedControl!
    @IBOutlet weak var timeSegmentControl: UISegmentedControl!
    @IBOutlet weak var penaltySwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSettings()
    }
    
    func prepareSettings() {
        let defaults = UserDefaultsManager.share
        let time = defaults.getInt(key: .timeRound)
        let round = defaults.getInt(key: .winPoints)
        let penalty = defaults.getBool(key: .penalty)
        roundSegmentControl.select(title: String(round))
        timeSegmentControl.select(title: String(time))
        penaltySwitch.isOn = penalty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let defaults = UserDefaultsManager.share
        if let round = roundSegmentControl.titleForSegment(at: roundSegmentControl.selectedSegmentIndex), let roundInt = Int(round) {
            defaults.setInt(item: roundInt, key: .winPoints)
        }
        if let time = timeSegmentControl.titleForSegment(at: timeSegmentControl.selectedSegmentIndex), let timeInt = Int(time) {
            defaults.setInt(item: timeInt, key: .timeRound)
        }
        let isOn = penaltySwitch.isOn
        defaults.setBool(item: isOn, key: .penalty)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = RuleViewController.instantiate(from: .main)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UISegmentedControl {
    func select(title: String) {
        let count = self.numberOfSegments
        for index in 0..<count {
            if let text = self.titleForSegment(at: index) {
                if text == title {
                    self.selectedSegmentIndex = index
                    return
                }
            }
        }
    }
}
