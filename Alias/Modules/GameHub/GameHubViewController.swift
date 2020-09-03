//
//  GameHubViewController.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

class GameHubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let cellInView = 4
    
    var presenter: GameHubPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
        tableView.reloadData()
    }

    
    func setupTableView() {
        self.tableView.register(type: TeamTableViewCell.self)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any?) {
        presenter.cancelButtonTapped()
    }
    
    @IBAction func gameButtonAction(_ sender: Any?) {
        presenter.gameButtonTapped()
    }

}

extension GameHubViewController: UITableViewDelegate {
    
}

extension GameHubViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfObject(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.getItem(at: indexPath)
        let cell = tableView.dequeueReusableCell(with: TeamTableViewCell.self, for: indexPath)
        cell.setup(item)
        
        cell.contentView.alpha = indexPath.row == presenter.currentTeamIndex ? 1 : 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let availableHeight = tableView.frame.height
        return availableHeight / CGFloat(cellInView)
    }
    
}

extension GameHubViewController: GameHubViewProtocol {
    
    func setMainImage(image: UIImage?) {
        self.mainImageView.image = image
    }
    
    func setTitleText(text: String?) {
        self.titleLabel.text = text
    }
}
