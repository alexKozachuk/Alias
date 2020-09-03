//
//  RouterMain.swift
//  Alias
//
//  Created by Sasha on 25/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showGameHub()
    func popToRoot()
    func showCardGame(team: Team)
    func dismiss()
    func popViewController(animated: Bool)
    func presentPauseMenu(delegate: CardGameDelegate)
    func showCardDeckSelect()
    func showSettings()
    func showResult(team: Team, dataSource: [Answer])
    func doublePopViewController()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController  = assemblyBuilder?.createMainModule(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func showGameHub() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController  = assemblyBuilder?.createGameHubModule(router: self) else { return }
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showCardGame(team: Team) {
        guard let navigationController = navigationController else { return }
        guard let mainViewController  = assemblyBuilder?.createCardGameModule(router: self, team: team)  else { return }
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func presentPauseMenu(delegate: CardGameDelegate) {
        guard let navigationController = navigationController else { return }
        guard let menuViewController = assemblyBuilder?.createPauseMenuModule(router: self, delegate: delegate) else { return }
        
        navigationController.present(menuViewController, animated: true)
   }
    
    func popViewController(animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: animated)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    func showCardDeckSelect() {
        guard let navigationController = navigationController else { return }
        guard let cardDeckSelect  = assemblyBuilder?.createCardDeckSelect(router: self) else { return }
        navigationController.pushViewController(cardDeckSelect, animated: true)
    }
    
    func showResult(team: Team, dataSource: [Answer]) {
        guard let navigationController = navigationController else { return }
        guard let resultViewController  = assemblyBuilder?.createResultModule(router: self, team: team, dataSource: dataSource) else { return }
        navigationController.pushViewController(resultViewController, animated: true)
    }
    
    func showSettings() {
        guard let navigationController = navigationController else { return }
        guard let settingsViewController = assemblyBuilder?.createSettings(router: self) else { return }
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    func doublePopViewController() {
        guard let navigationController = navigationController else { return }
        let vcArray =  navigationController.viewControllers
        guard vcArray.count >= 3 else { return }
        
        navigationController.popToViewController(vcArray[vcArray.count - 3], animated: true)
    }
    
}
