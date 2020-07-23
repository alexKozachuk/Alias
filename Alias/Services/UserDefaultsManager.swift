//
//  UserDefaultsManager.swift
//  Alias
//
//  Created by Sasha on 22/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    enum IntKey: String {
        case timeRound
        case winPoints
    }
    
    enum BoolKey: String {
        case penalty
        case firstRun
    }
    private let defaults = UserDefaults.standard
    
    static let share = UserDefaultsManager()
    
    private init() {}
    
    func setInt(item: Int, key: IntKey) {
        defaults.set(item, forKey: key.rawValue)
    }
    
    func setBool(item: Bool, key: BoolKey) {
        defaults.set(item, forKey: key.rawValue)
    }
    
    func getInt(key: IntKey) -> Int {
        return defaults.integer(forKey: key.rawValue)
    }
    
    func getBool(key: BoolKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
}
