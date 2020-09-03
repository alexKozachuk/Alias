//
//  SettingsProtocol.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol SettingsViewProtocol: class {
    func saveSettings()
}

protocol SettingsPresenterProtocol: class {
    
    var settingsMenu: [SettingsMenu] { get set }
    var time: [String] { get }
    var points: [String] { get }
    var selectedTime: String! { get set }
    var selectedPoints: String! { get set }
    var isPenalty: Bool! { get set }
    
    init(router: RouterProtocol, view: SettingsViewProtocol)
    func save(isPenalty: Bool)
    func save(time: String)
    func save(points: String)
    
    func backButtonTapped()
}
