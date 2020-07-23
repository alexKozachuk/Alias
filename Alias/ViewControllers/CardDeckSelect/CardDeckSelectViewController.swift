//
//  CardDeckSelectViewController.swift
//  Alias
//
//  Created by Sasha on 20/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

class CardDeckSelectViewController: UIViewController {

    private let goldenRatio: Double = 1.3
    private let itemsPerRow: Int = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    
    var fetchedResultsController: NSFetchedResultsController<CardDeck> = {
        let fetchRequest: NSFetchRequest<CardDeck> = CardDeck.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()

    var blockOperations: [BlockOperation] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        fetchedResultsController.delegate = self
        setupCardDeck()
    }
    
    func setupCollectionView() {
        collectionView.register(type: SetCollectionViewCell.self)
        //collectionView.allowsMultipleSelection = true
    }
    
    func setupCardDeck() {
        guard let items = fetchedResultsController.fetchedObjects else { return }
        guard !items.isEmpty else { return }
        if items.count > 0 {
            for (number, item) in items.enumerated() {
                item.isActive = number == 0 ? true : false
            }
        } else {
            items[0].isActive = true
        }
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
    }

    @IBAction func continueButtonTapped(_ sender: Any?) {
        let vc = GameHubViewController.instantiate(from: .main)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any?) {
        let ac = UIAlertController(title: "Створення набору", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            guard let textField = ac.textFields?[0] else { return }
            guard let text = textField.text else { return }
            print(text)
            let cardDeck = CardDeck()
            cardDeck.name = text
            
        }))
        present(ac, animated: true)
    }
    
    @IBAction func switchValueChanged() {
        isEditing.toggle()
    }
    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }

        blockOperations.removeAll(keepingCapacity: false)
    }
    
}

extension CardDeckSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isActive = true
        if isEditing {
            let item = fetchedResultsController.object(at: indexPath)
            let vc = TestDBViewController.instantiate(from: .main)
            vc.setupDataSource(item)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isActive = false
    }
    
}

extension CardDeckSelectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardDeck = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(with: SetCollectionViewCell.self, for: indexPath)
        cell.setup(cardDeck)
        return cell
    }

}


extension CardDeckSelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpaceLeft = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpaceLeft
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem / CGFloat(goldenRatio))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}

extension CardDeckSelectViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                let blockOperation =  BlockOperation(block: { [weak self] in
                    self?.collectionView.insertItems(at: [indexPath])
                })
                blockOperations.append(blockOperation)
            }
        case .update:
            if let indexPath = indexPath {
                let blockOperation =  BlockOperation(block: { [weak self] in
                    guard let cardDesk = self?.fetchedResultsController.object(at: indexPath)
                        else { return }
                    guard let cell = self?.collectionView.dequeueReusableCell(with: SetCollectionViewCell.self, for: indexPath) else { return }
                    cell.nameLabel.text = cardDesk.name
                })
                blockOperations.append(blockOperation)
            }
        case .move:
            let blockOperation =  BlockOperation(block: { [weak self] in
                if let indexPath = indexPath {
                    self?.collectionView.deleteItems(at: [indexPath])
                }
                if let newIndexPath = newIndexPath {
                    self?.collectionView.insertItems(at: [newIndexPath])
                }
            })
            blockOperations.append(blockOperation)
        case .delete:
            let blockOperation =  BlockOperation(block: { [weak self] in
                if let indexPath = indexPath {
                    self?.collectionView.deleteItems(at: [indexPath])
                }
            })
            blockOperations.append(blockOperation)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
}
