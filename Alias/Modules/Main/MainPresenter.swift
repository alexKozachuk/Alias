//
//  MainPresenter.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation
import CoreData

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var coreDataService: CoreDataService!
    var fetchedResultsController: NSFetchedResultsController<Team>!
    
    required init(view: MainViewProtocol, model: CoreDataService, router: RouterProtocol) {
        self.view = view
        self.coreDataService = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        fetchedResultsController = coreDataService.teamFetchedResultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        fetchedResultsController.fetchedObjects?.forEach { item in
            item.clear()
        }
        
        let indexPaths = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]
        indexPaths.forEach { index in
            fetchedResultsController.object(at: index).isActive = true
            view?.selectItemAtIndexPath(indexPath: index)
        }
    }
    
    func viewWillAppear() {
        fetchedResultsController.fetchedObjects?.forEach { item in
            item.points = 0
        }
        CoreDataManager.share.saveContext()
    }
    
    func itemDidSelect(at indexPath: IndexPath) {
        fetchedResultsController.object(at: indexPath).isActive = true
        CoreDataManager.share.saveContext()
    }
    
    func itemDidDeselect(at indexPath: IndexPath) {
        fetchedResultsController.object(at: indexPath).isActive = false
        CoreDataManager.share.saveContext()
    }
    
    func numberOfObject(in section: Int) -> Int{
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func getItem(at indexPath: IndexPath) -> Team {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func checkSelection() {
        guard let items = fetchedResultsController.fetchedObjects else { return }
        
        for item in items where item.isActive == true {
            if let indexPath = fetchedResultsController.indexPath(forObject: item) {
                view?.selectItemAtIndexPath(indexPath: indexPath)
            }
        }
    }
    
    func continueButtonTapped() {
        router?.showCardDeckSelect()
    }
    
    func settingsButtonTapped() {
        router?.showSettings()
    }
}
