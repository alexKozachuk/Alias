//
//  GameHubViewController.swift
//  Alias
//
//  Created by Sasha on 17/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

protocol GameHubDelegate {
    func prepareNextTeam(count: Int)
}

class GameHubViewController: UIViewController {

    var currentTeamIndex: Int = 0
    var countTeam: Int = 0
    var fetchedResultsController: NSFetchedResultsController<Team> = {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isActive == true")
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    var winPoints = 25
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let cellInView = 4
    
    var isWin: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        fetchedResultsController.delegate = self
        if let count = fetchedResultsController.fetchedObjects?.count {
            countTeam = count
        }
        prepareDefaults()
    }
    func prepareDefaults() {
        let defaults = UserDefaultsManager.share
        winPoints = defaults.getInt(key: .winPoints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isWin {
            setupCurrentTeam()
            tableView.reloadData()
        }
    }
    
    func setupCurrentTeam() {
        guard let items = fetchedResultsController.fetchedObjects else { return }
        guard items.count > currentTeamIndex else { return }
        let item = items[currentTeamIndex]
        titleLabel.text = "Черга команди \"\(item.name ?? "none")\""
        mainImageView.image = item.photo
    }
    
    func setupTableView() {
        self.tableView.register(type: TeamTableViewCell.self)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any?) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func gameButtonAction(_ sender: Any?) {
        guard !isWin else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        guard let item = fetchedResultsController.fetchedObjects?[currentTeamIndex] else { return }
        let vc = CardGameViewController.instantiate(from: .main)
        vc.delegate = self
        vc.setup(team: item)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension GameHubViewController: UITableViewDelegate {
    
}

extension GameHubViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(with: TeamTableViewCell.self, for: indexPath)
        cell.setup(item)
        print(indexPath.row)
        if indexPath.row != currentTeamIndex {
            cell.contentView.alpha = 0.5
        } else {
            cell.contentView.alpha = 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let availableHeight = tableView.frame.height
        return availableHeight / CGFloat(cellInView)
    }
    
}

extension GameHubViewController: GameHubDelegate {
    func prepareNextTeam(count: Int) {
        guard let item = fetchedResultsController.fetchedObjects?[currentTeamIndex] else { return }
        item.points += Int16(count)
        if item.points < 0 {
            item.points = 0
        }
        if item.points >= winPoints {
            self.isWin = true
            titleLabel.text = "Перемогла команда \"\(item.name ?? "none")\""
        }
        currentTeamIndex += 1
        if currentTeamIndex == countTeam {
            currentTeamIndex = 0
        }
    }
    
}

extension GameHubViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = newIndexPath {
                let team = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! TeamTableViewCell
                cell.teamNameLabel.text = team.name
                cell.pointCountLabel.text = String(team.points)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

