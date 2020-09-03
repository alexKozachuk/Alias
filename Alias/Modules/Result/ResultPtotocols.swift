//
//  ResultPtotocols.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol ResultViewProtocol: class {
    func didSelectRow(at indexPath: IndexPath)
}

protocol ResultPresenterProtocol: class {
    var dataSource: [Answer] { get set }
    init(view: ResultViewProtocol, router: RouterProtocol, team: Team, dataSource: [Answer])
    func viewDidLoad()
    func continueButtonTapped()
    func didSelectRow(at indexPath: IndexPath)
}
