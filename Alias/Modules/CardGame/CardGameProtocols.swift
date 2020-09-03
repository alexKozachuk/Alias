//
//  CardGameProtocols.swift
//  Alias
//
//  Created by Sasha on 25/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol CardGameViewProtocol: class {
    func setCurrentCountLabel(text: String?)
    func setMaxCountLabelLabel(text: String?)
    func setTimeLabelLabel(text: String?)
    func setCardNameLabel(text: String?)
    func startTimer(with duration: Double)
    func pauseTimer()
    func resumeTimer()
}

protocol CardGamePresenterProtocol: class {
    var maxCount: Int { get }
    init(view: CardGameViewProtocol, coreDataService: CoreDataService, router: RouterProtocol, team: Team)
    func viewDidLoad()
    func cardSwiped(text: String, isPositive: Bool)
    func pauseButtonTapped()
}

// Change with DB
protocol CardGameDelegate {
    func popToRootViewController(animated: Bool)
    func popViewController(animated: Bool)
    func popViewControllerWithCount(animated: Bool, count: Int)
    func resume()
}
