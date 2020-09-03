//
//  PauseMenuProtocols.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol PauseMenuViewProtocol: class {
    
}

protocol PauseMenuPresenterProtocol: class {
    init(view: PauseMenuViewProtocol, router: RouterProtocol, delegate: CardGameDelegate)
    func exitButtonPressed()
    func continueButtonPressed()
}
