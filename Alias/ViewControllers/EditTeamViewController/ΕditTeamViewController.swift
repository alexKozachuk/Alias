//
//  ΕditTeamViewController.swift
//  Alias
//
//  Created by Sasha on 23/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol EditTeamViewControllerDelegate {
    func didSave()
}

class EditTeamViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var team: Team!
    var oldValue: String!
    var delegate: EditTeamViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    func setup(team: Team, delegate: EditTeamViewControllerDelegate) {
        self.team = team
        self.delegate = delegate
    }
    
    func prepareData() {
        oldValue = team.name
        textField?.text = team.name
        imageView?.image = team.photo
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ReadyButtonTapped(_ sender: Any?) {
        
        guard let name = textField.text else { return }
        if name != oldValue {
            team.name = name
            CoreDataManager.share.saveContext()
        }
        delegate.didSave()
        self.dismiss(animated: true)
    }

}
