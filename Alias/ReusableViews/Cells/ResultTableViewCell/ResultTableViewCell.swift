//
//  ResultTableViewCell.swift
//  Alias
//
//  Created by Sasha on 19/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBox: UISwitch!
    
    func setup(answer: Answer) {
        nameLabel.text = answer.name
        checkBox.isOn = answer.isAnswered
    }
    
    func setup(text: String, isOn: Bool) {
        nameLabel.text = text
        checkBox.isOn = isOn
    }
    
}
