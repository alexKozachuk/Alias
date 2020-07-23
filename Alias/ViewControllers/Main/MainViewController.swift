//
//  ViewController.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, MainView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    
    private let itemsPerRow: CGFloat = 2
    private let itemsPerScreen: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    var blockOperations: [BlockOperation] = []
    
    var fetchedResultsController: NSFetchedResultsController<Team> = {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        fetchedResultsController.delegate = self
        setupSelection()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultsController.fetchedObjects?.forEach { item in
            item.points = 0
        }
        CoreDataManager.share.saveContext()
    }
    
    func setupCollectionView() {
        self.collectionView.register(type: TeamCollectionViewCell.self)
        self.collectionView.allowsMultipleSelection = true
    }
    
    func setupSelection() {
        fetchedResultsController.fetchedObjects?.forEach { item in
            item.clear()
        }
        
        let indexPaths = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]
        indexPaths.forEach { index in
            fetchedResultsController.object(at: index).isActive = true
            collectionView.selectItem(at: index, animated: false, scrollPosition: .top)
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any?) {
        let vc = SettingsContainerViewController.instantiate(from: .main)
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any?) {
//        guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
//        guard indexPaths.count >= 2 else { return }
//
//        let items = indexPaths.map {
//            return dataSource[$0.item]
//        }
        
        
        let vc = CardDeckSelectViewController.instantiate(from: .main)
        //vc.setup(items: items)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSelection()
        fetchedResultsController.object(at: indexPath).isActive = true
        CoreDataManager.share.saveContext()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        checkSelection()
        fetchedResultsController.object(at: indexPath).isActive = false
        CoreDataManager.share.saveContext()
    }
    
    func checkSelection() {
        guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
        if indexPaths.count < 2 {
            continueButton.isEnabled = false
            continueButton.isUserInteractionEnabled = false
            continueButton.alpha = 0.6
        } else {
            continueButton.isEnabled = true
            continueButton.isUserInteractionEnabled = true
            continueButton.alpha = 1
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(with: TeamCollectionViewCell.self, for: indexPath)
        cell.setup(team: item)
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpaceLeft = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpaceLeft
        let availableHeight = collectionView.frame.height - sectionInsets.top * (itemsPerScreen + 1)
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerRow = availableHeight / itemsPerScreen
        return CGSize(width: widthPerItem, height: heightPerRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}

extension MainViewController: NSFetchedResultsControllerDelegate {
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
                    guard let cell = self?.collectionView.dequeueReusableCell(with: TeamCollectionViewCell.self, for: indexPath) else { return }
                    cell.colorView.backgroundColor = cardDesk.color
                    cell.imageView.image = cardDesk.photo
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
