//
//  ResultViewController.swift
//  Alias
//
//  Created by Sasha on 19/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var presenter: ResultPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    func setupTableView() {
        tableView.register(type: ResultTableViewCell.self)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any?) {
        presenter.continueButtonTapped()
    }

}

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.didSelectRow(at: indexPath)
       
    }
    
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: ResultTableViewCell.self, for: indexPath)
        cell.setup(answer: item)
        return cell
    }
    
    
}

extension ResultViewController: ResultViewProtocol {
    func didSelectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
