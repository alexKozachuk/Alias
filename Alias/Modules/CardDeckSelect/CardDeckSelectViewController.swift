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
    
    var presenter: CardDeckSelectPresenterProtocol!
    //var blockOperations: [BlockOperation] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        presenter.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
        presenter.viewDidLayoutSubviews()
    }
    
    func setupCollectionView() {
        collectionView.register(type: SetCollectionViewCell.self)
        //collectionView.allowsMultipleSelection = true
    }

    @IBAction func continueButtonTapped(_ sender: Any?) {
        presenter.continueButtonTapped()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any?) {
        presenter.cancelButtonTapped()
    }
    
}

extension CardDeckSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        presenter.didDeselectItem(at: indexPath)
    }
    
}

extension CardDeckSelectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfObject(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardDeck = presenter.getItem(at: indexPath)
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

extension CardDeckSelectViewController: CardDeckSelectViewProtocol {
    
    func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
    
}

//extension CardDeckSelectViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        blockOperations.removeAll(keepingCapacity: false)
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            if let indexPath = newIndexPath {
//                let blockOperation =  BlockOperation(block: { [weak self] in
//                    self?.collectionView.insertItems(at: [indexPath])
//                })
//                blockOperations.append(blockOperation)
//            }
//        case .update:
//            if let indexPath = indexPath {
//                let blockOperation =  BlockOperation(block: { [weak self] in
//                    guard let cardDesk = self?.fetchedResultsController.object(at: indexPath)
//                        else { return }
//                    guard let cell = self?.collectionView.dequeueReusableCell(with: SetCollectionViewCell.self, for: indexPath) else { return }
//                    cell.nameLabel.text = cardDesk.name
//                })
//                blockOperations.append(blockOperation)
//            }
//        case .move:
//            let blockOperation =  BlockOperation(block: { [weak self] in
//                if let indexPath = indexPath {
//                    self?.collectionView.deleteItems(at: [indexPath])
//                }
//                if let newIndexPath = newIndexPath {
//                    self?.collectionView.insertItems(at: [newIndexPath])
//                }
//            })
//            blockOperations.append(blockOperation)
//        case .delete:
//            let blockOperation =  BlockOperation(block: { [weak self] in
//                if let indexPath = indexPath {
//                    self?.collectionView.deleteItems(at: [indexPath])
//                }
//            })
//            blockOperations.append(blockOperation)
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView!.performBatchUpdates({ () -> Void in
//            for operation: BlockOperation in self.blockOperations {
//                operation.start()
//            }
//        }, completion: { (finished) -> Void in
//            self.blockOperations.removeAll(keepingCapacity: false)
//        })
//    }
//
//}
