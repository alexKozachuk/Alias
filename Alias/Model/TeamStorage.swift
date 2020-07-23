//
//  TeamStoarge.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class TeamTest {
    var color: UIColor
    var image: UIImage
    var name: String
    var points: Int
    
    init(color: UIColor, image: UIImage, name: String, points: Int = 0) {
        self.color = color
        self.image = image
        self.name = name
        self.points = points
    }
    
}

class TeamStoarge {
    var teams: [TeamTest]
    static let shared: TeamStoarge = TeamStoarge()
    
    private init() {
        let first = TeamTest(color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), image: #imageLiteral(resourceName: "dog1"), name: "Благородні Далматини")
        let second = TeamTest(color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), image: #imageLiteral(resourceName: "dog4"), name: "Горді Вівчарки")
        let third = TeamTest(color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), image: #imageLiteral(resourceName: "dog3"), name: "Вухаті Спаніелі")
        let fifth = TeamTest(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), image: #imageLiteral(resourceName: "dog2"), name: "Дикі Гієни")
        teams = [first,second, third, fifth]
    }
    
}
