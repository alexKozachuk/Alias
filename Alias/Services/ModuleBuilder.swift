//
//  ModuleBuilder.swift
//  Alias
//
//  Created by Sasha on 24/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createGameHubModule(router: RouterProtocol) -> UIViewController
    func createCardGameModule(router: RouterProtocol, team: Team) -> UIViewController
    func createPauseMenuModule(router: RouterProtocol, delegate: CardGameDelegate) -> UIViewController
    func createCardDeckSelect(router: RouterProtocol) -> UIViewController
    func createResultModule(router: RouterProtocol, team: Team, dataSource: [Answer]) -> UIViewController
    func createSettings(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol {
    
    func createSettings(router: RouterProtocol) -> UIViewController{
        let view = SettingsViewController()
        let presenter = SettingsPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createGameHubModule(router: RouterProtocol) -> UIViewController {
        let view = GameHubViewController()
        let coreDataService = CoreDataService()
        let presenter = GameHubPresenter(view: view, model: coreDataService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let coreDataService = CoreDataService()
        let presenter = MainPresenter(view: view, model: coreDataService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createCardGameModule(router: RouterProtocol, team: Team) -> UIViewController {
        let view = CardGameViewController()
        let coreDataService = CoreDataService()
        let presenter = CardGamePresenter(view: view, coreDataService: coreDataService, router: router, team: team)
        view.presenter = presenter
        return view
    }
    
    func createPauseMenuModule(router: RouterProtocol, delegate: CardGameDelegate) -> UIViewController {
        let view = PauseMenuViewController()
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve
        let presenter = PauseMenuPresenter(view: view, router: router, delegate: delegate)
        view.presenter = presenter
        return view
    }
    
    func createCardDeckSelect(router: RouterProtocol) -> UIViewController {
        let view = CardDeckSelectViewController()
        let presenter = CardDeckSelectPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createResultModule(router: RouterProtocol, team: Team, dataSource: [Answer]) -> UIViewController {
        let view = ResultViewController()
        let presenter = ResultPresenter(view: view, router: router, team: team, dataSource: dataSource)
        view.presenter = presenter
        return view
    }
    
}
