//
//  TestDBViewController.swift
//  Alias
//
//  Created by Sasha on 21/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

class TestDBViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: CardDeck!
    var fetchedResultsController: NSFetchedResultsController<Card>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchResultController()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func setupFetchResultController() {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest(cardDeck: dataSource)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = self
    }
    
    func setupDataSource(_ dataSource: CardDeck) {
        self.dataSource = dataSource
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
        CoreDataManager.share.saveContext()
    }
    
    @IBAction func addButtonTapped(_ sender: Any?) {
        let ac = UIAlertController(title: "Додавання слова", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            guard let textField = ac.textFields?[0] else { return }
            guard let text = textField.text else { return }
            guard let dataSource = self?.dataSource else { return }
            print(text)
            let card = Card()
            card.name = text
            card.cardDeck = dataSource
        }))
        present(ac, animated: true)
    }
    
}

extension TestDBViewController: UITableViewDelegate {
    
}

extension TestDBViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return  sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = item.name
        return cell
    }
    
    
}

extension TestDBViewController: NSFetchedResultsControllerDelegate {
    
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
                let cardDeck = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = cardDeck.name
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
