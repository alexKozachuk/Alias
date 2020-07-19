//
//  GameHubViewController.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class GameHubViewController: UIViewController {

    var dataSource: [Team] = []
    
    @IBOutlet weak var tableView: UITableView!
    let cellInView = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    public func setup(dataSource: [Team]) {
        self.dataSource = dataSource
    }
    
    func setupTableView() {
        self.tableView.register(type: TeamTableViewCell.self)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gameButtonAction(_ sender: Any?) {
        let vc = CardGameViewController.instantiate(from: .main)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension GameHubViewController: UITableViewDelegate {
    
}

extension GameHubViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: TeamTableViewCell.self, for: indexPath)
        cell.setup(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let availableHeight = tableView.frame.height
        return availableHeight / CGFloat(cellInView)
    }
    
}
