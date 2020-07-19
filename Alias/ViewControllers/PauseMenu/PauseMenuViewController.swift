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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButtonPressed(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitButtonPressed(_ sender: Any?) {
        delegate.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
