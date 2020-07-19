//
//  MainProtocols.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol MainView: class {
    
}

protocol MainViewPresenter {
    init(view: MainView)
}
