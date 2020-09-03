//
//  SettingsPresenter.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

enum SettingsMenu: String, CaseIterable {
    case rules = "Правила"
    case time = "Кількість балів для перемоги"
    case points = "Час одного раунду"
    case penalty = "Віднімання балів за пропуск"
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    
    var settingsMenu = SettingsMenu.allCases
    weak var view: SettingsViewProtocol!
    var router: RouterProtocol?
       
    let time = ["30", "60", "90"]
    let points = ["25", "50", "75", "100"]
    var selectedTime: String!
    var selectedPoints: String!
    var isPenalty: Bool!
    let defaults = UserDefaultsManager.share
    
    required init(router: RouterProtocol, view: SettingsViewProtocol) {
        self.router = router
        self.view = view
        prepareSettings()
    }
    
    func prepareSettings() {
        
        let time = defaults.getInt(key: .timeRound)
        let point = defaults.getInt(key: .winPoints)
        isPenalty = defaults.getBool(key: .penalty)
        selectedTime = String(time)
        selectedPoints = String(point)
    }
    
    func save(isPenalty: Bool) {
        defaults.setBool(item: isPenalty, key: .penalty)
    }
    
    func save(time: String) {
        guard let time = Int(time) else { return }
        defaults.setInt(item: time, key: .timeRound)
    }
    
    func save(points: String) {
         guard let points = Int(points) else { return }
        defaults.setInt(item: points, key: .winPoints)
    }
    
    func backButtonTapped() {
        router?.popViewController(animated: true)
        view.saveSettings()
    }
}
