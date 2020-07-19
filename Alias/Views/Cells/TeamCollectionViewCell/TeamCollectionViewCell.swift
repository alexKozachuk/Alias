//
//  CollectionViewCell.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.layer.opacity = isSelected ? 1.0 : 0.8
        }
    }
    
    func setup(team: Team) {
        imageView.image = team.image
        colorView.backgroundColor = team.color
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
    }
}
