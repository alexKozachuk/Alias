//
//  PauseMenuPresenter.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

class PauseMenuPresenter: PauseMenuPresenterProtocol {
    
    weak var view: PauseMenuViewProtocol!
    var router: RouterProtocol?
    var delegate: CardGameDelegate!
    
    required init(view: PauseMenuViewProtocol, router: RouterProtocol, delegate: CardGameDelegate) {
        self.view = view
        self.router = router
        self.delegate = delegate
    }
    
    func continueButtonPressed() {
        router?.dismiss()
        delegate.resume()
    }
    
    func exitButtonPressed() {
        router?.popToRoot()
        router?.dismiss()
    }
    
}
