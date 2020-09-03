//
//  CardDeckPresenter.swift
//  Alias
//
//  Created by Sasha on 26/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreData

class CardDeckSelectPresenter: CardDeckSelectPresenterProtocol {
    weak var view: CardDeckSelectViewProtocol!
    var router: RouterProtocol!
    
    var fetchedResultsController: NSFetchedResultsController<CardDeck> = {
           let fetchRequest: NSFetchRequest<CardDeck> = CardDeck.fetchRequest()
           let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
           fetchRequest.sortDescriptors = [sortDescriptor]
           let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
           return fetchedResultsController
       }()
    
    required init(view: CardDeckSelectViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        do {
                   try fetchedResultsController.performFetch()
               } catch {
                   print(error)
               }
        //fetchedResultsController.delegate = self
    }
    
    func viewDidLayoutSubviews() {
        setupCardDeck()
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
        view.selectItem(at: IndexPath(item: 0, section: 0))
    }
    
    func continueButtonTapped() {
        router.showGameHub()
    }
    
    func cancelButtonTapped() {
        router.popViewController(animated: true)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isActive = true
        CoreDataManager.share.saveContext()
    }
    
    func didDeselectItem(at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        item.isActive = false
        CoreDataManager.share.saveContext()
    }
    
    func numberOfObject(in section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func getItem(at indexPath: IndexPath) -> CardDeck {
        return fetchedResultsController.object(at: indexPath)
    }
}
