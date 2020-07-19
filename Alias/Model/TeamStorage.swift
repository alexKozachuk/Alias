//
//  TeamStoarge.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

class TeamStoarge {
    var teams: [Team]
    static let shared: TeamStoarge = TeamStoarge()
    
    private init() {
        let first = Team(color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), image: #imageLiteral(resourceName: "dog1"), name: "Благородні Далматини")
        let second = Team(color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), image: #imageLiteral(resourceName: "dog4"), name: "Гордні Вівчарки")
        let third = Team(color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), image: #imageLiteral(resourceName: "dog3"), name: "Вухаті Спаніелі")
        let fifth = Team(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), image: #imageLiteral(resourceName: "dog2"), name: "Дикі Гієни")
        teams = [first,second, third, fifth]
    }
    
}
