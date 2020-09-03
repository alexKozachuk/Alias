//
//  ResultPresenter.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

class ResultPresenter: ResultPresenterProtocol {
    
    var dataSource: [Answer] = []
    
    weak var view: ResultViewProtocol!
    var router: RouterProtocol!
    var penalty: Bool = true
    var team: Team!
    
    required init(view: ResultViewProtocol, router: RouterProtocol, team: Team, dataSource: [Answer]) {
        self.view = view
        self.router = router
        self.team = team
        self.dataSource = dataSource
    }
    
    func viewDidLoad() {
        setupDefaults()
    }
    
    func setupDefaults() {
        let defaults = UserDefaultsManager.share
        penalty = defaults.getBool(key: .penalty)
    }
    
    func continueButtonTapped() {
        var count: Int16 = 0
        
        if penalty {
            count = dataSource.reduce(0) { $0 + ($1.isAnswered ? 1 : -1)}
        } else {
            count = dataSource.reduce(0) { $0 + ($1.isAnswered ? 1 : 0)}
        }
        
        team.points += count
        CoreDataManager.share.saveContext()
        
        router.doublePopViewController()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        dataSource[indexPath.row].isAnswered.toggle()
        view.didSelectRow(at: indexPath)
    }
    
}
