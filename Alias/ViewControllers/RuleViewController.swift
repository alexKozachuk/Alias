//
//  RuleViewController.swift
//  Alias
//
//  Created by Sasha on 23/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class RuleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonTapped(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}
