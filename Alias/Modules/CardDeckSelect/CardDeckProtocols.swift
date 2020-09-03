//
//  CardDeckProtocols.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

protocol CardDeckSelectViewProtocol: class {
    func selectItem(at indexPath: IndexPath)
}

protocol CardDeckSelectPresenterProtocol: class {
    init(view: CardDeckSelectViewProtocol, router: RouterProtocol)
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func cancelButtonTapped()
    func continueButtonTapped()
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func numberOfObject(in section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> CardDeck
}
