//
//  SettingsContainerViewController.swift
//  Alias
//
//  Created by Sasha on 22/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit


 
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: SettingsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.register(type: SegmentControlTableViewCell.self)
        self.tableView.register(type: SwitchTableViewCell.self)
    }
    
    @IBAction func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
}

extension SettingsViewController: SettingsViewProtocol {
    
    func saveSettings() {
        for (index, item) in presenter.settingsMenu.enumerated() {
            switch item {
            case .penalty:
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SwitchTableViewCell
                presenter.save(isPenalty: cell.checkBox.isOn)
            case .time:
               let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SegmentControlTableViewCell
               let index = cell.segmentControll.selectedSegmentIndex
               guard let item = cell.segmentControll.titleForSegment(at: index) else { return }
               presenter.save(time:  item)
            case .points:
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SegmentControlTableViewCell
                let index = cell.segmentControll.selectedSegmentIndex
                guard let item = cell.segmentControll.titleForSegment(at: index) else { return }
                presenter.save(points: item)
            default:
                break
            }
        }
        
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.settingsMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.settingsMenu[indexPath.row]
        
        switch item {
        case .rules:
            let cell = UITableViewCell()
            cell.textLabel?.text = item.rawValue
            return cell
        case .points:
            let cell = tableView.dequeueReusableCell(with: SegmentControlTableViewCell.self, for: indexPath)
            cell.segmentControll.configure(with: presenter.points, selected: presenter.selectedPoints)
            cell.nameLabel.text = item.rawValue
            return cell
        case .time:
            let cell = tableView.dequeueReusableCell(with: SegmentControlTableViewCell.self, for: indexPath)
            cell.segmentControll.configure(with: presenter.time, selected: presenter.selectedTime)
            cell.nameLabel.text = item.rawValue
            return cell
        case .penalty:
            let cell = tableView.dequeueReusableCell(with: SwitchTableViewCell.self, for: indexPath)
            cell.setup(text: item.rawValue, isOn: presenter.isPenalty)
            return cell
        }
        
        
    }
    
    
}
