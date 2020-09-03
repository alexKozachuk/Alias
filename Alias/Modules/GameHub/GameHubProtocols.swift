//
//  GameHubProtocols.swift
//  Alias
//
//  Created by Sasha on 25/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol GameHubDelegate {
    func prepareNextTeam(count: Int)
}

protocol GameHubViewProtocol: class {
    func setTitleText(text: String?)
    func setMainImage(image: UIImage?)
}

protocol GameHubPresenterProtocol: class {
    var currentTeamIndex: Int { get }
    init(view: GameHubViewProtocol, model: CoreDataService, router: RouterProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func cancelButtonTapped()
    func gameButtonTapped()
    func numberOfObject(in section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> Team
}
