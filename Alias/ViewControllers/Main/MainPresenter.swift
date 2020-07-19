//
//  MainPresenter.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

class MainPresenter {
    unowned let view: MainView
    required init(view: MainView) {
        self.view = view
    }
}
