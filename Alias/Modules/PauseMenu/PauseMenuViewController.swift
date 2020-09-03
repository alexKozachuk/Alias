//
//  PauseMenuViewController.swift
//  Alias
//
//  Created by Sasha on 19/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class PauseMenuViewController: UIViewController {

    var delegate: CardGameDelegate!
    var presenter: PauseMenuPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any?) {
        presenter.continueButtonPressed()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any?) {
        presenter.exitButtonPressed()
    }
    
}

extension PauseMenuViewController: PauseMenuViewProtocol {
    
}
