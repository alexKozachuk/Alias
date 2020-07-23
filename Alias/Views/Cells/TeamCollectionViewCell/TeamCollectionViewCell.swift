//
//  CollectionViewCell.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol TeamCollectionViewCellDelegate {
    func editButtonTapped(team: Team)
}

class TeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate: TeamCollectionViewCellDelegate!
    
    // TODO: remove it
    var team: Team!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.layer.opacity = isSelected ? 1.0 : 0.8
        }
    }
    
    func setup(team: Team, delegate: TeamCollectionViewCellDelegate) {
        imageView.image = team.photo
        colorView.backgroundColor = team.color
        nameLabel.text = team.name
        self.delegate = delegate
        self.team = team
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
    }
    
    @IBAction func editButtonTapped() {
        delegate.editButtonTapped(team: self.team)
    }
}

