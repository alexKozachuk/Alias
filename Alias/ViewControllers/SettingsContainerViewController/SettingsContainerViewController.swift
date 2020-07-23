//
//  SettingsContainerViewController.swift
//  Alias
//
//  Created by Sasha on 22/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class SettingsContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
