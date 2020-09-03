//
//  SwitchTableViewCell.swift
//  Alias
//
//  Created by Sasha on 27/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBox: UISwitch!
    
    func setup(text: String, isOn: Bool) {
        nameLabel.text = text
        checkBox.isOn = isOn
    }
    
}
