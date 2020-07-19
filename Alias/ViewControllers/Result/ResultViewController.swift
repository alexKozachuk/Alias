//
//  ResultViewController.swift
//  Alias
//
//  Created by Sasha on 19/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var dataSource: [Answer] = [Answer(name: "Кухня", isAnswered: true),
                                Answer(name: "Духовка", isAnswered: false),
                                Answer(name: "Саня", isAnswered: true)]
    var delegate: CardGameDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(type: ResultTableViewCell.self)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any?) {
        let count = dataSource.reduce(0) { $0 + ($1.isAnswered ? 1 : 0)}
        print(count)
        navigationController?.popViewController(animated: false)
        delegate?.popViewController(animated: true)
    }

}

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO : Make animation
        tableView.deselectRow(at: indexPath, animated: false)
        dataSource[indexPath.row].isAnswered.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: ResultTableViewCell.self, for: indexPath)
        cell.setup(answer: item)
        return cell
    }
    
    
}
