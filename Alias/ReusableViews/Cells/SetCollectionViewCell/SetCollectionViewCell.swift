//
//  SetCollectionViewCell.swift
//  Alias
//
//  Created by Sasha on 20/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class SetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            selectedImageView.isHidden = !isSelected
        }
    }
    
    func setup(_ cardDeck: CardDeck) {
        nameLabel.text = cardDeck.name
        backgroundImageView.image = cardDeck.photo
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
    }
}
