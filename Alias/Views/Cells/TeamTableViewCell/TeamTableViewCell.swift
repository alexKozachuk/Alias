//
//  TeamTableViewCell.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var pointCountLabel: UILabel!
    
    func setup(_ team: Team) {
        teamImageView.image = team.photo
        teamNameLabel.text = team.name
        pointCountLabel.text = String(team.points)
    }
}
