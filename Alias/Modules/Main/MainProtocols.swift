//
//  MainProtocols.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func selectItemAtIndexPath(indexPath: IndexPath)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, model: CoreDataService, router: RouterProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func itemDidSelect(at indexPath: IndexPath)
    func itemDidDeselect(at indexPath: IndexPath)
    func numberOfObject(in section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> Team
    func checkSelection()
    func continueButtonTapped()
    func settingsButtonTapped()
}
