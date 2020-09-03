//
//  GameHubPresenter.swift
//  Alias
//
//  Created by Sasha on 25/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreData

class GameHubPresenter: GameHubPresenterProtocol  {
    
    var currentTeamIndex: Int = 0
    var countTeam: Int = 0
    
    var fetchedResultsController: NSFetchedResultsController<Team> = {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "objectID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "isActive == true")
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    var winPoints = 25
    var isWin: Bool = false
    
    weak var view: GameHubViewProtocol?
    var coreDataService: CoreDataService!
    var router: RouterProtocol?
    
    required init(view: GameHubViewProtocol, model: CoreDataService, router: RouterProtocol) {
        self.view = view
        self.coreDataService = model
        self.router = router
    }
    
    func viewDidLoad() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        if let count = fetchedResultsController.fetchedObjects?.count {
            countTeam = count
        }
        
        let defaults = UserDefaultsManager.share
        winPoints = defaults.getInt(key: .winPoints)
    }
    
    func viewWillAppear() {
        if !isWin {
            setupCurrentTeam()
        }
    }
    
    func setupCurrentTeam() {
        guard let item = getCurrentTeam() else { return }
        view?.setMainImage(image: item.photo)
        view?.setTitleText(text: item.name)
    }
    
    func getCurrentTeam() -> Team?{
        guard let items = fetchedResultsController.fetchedObjects else { return nil }
        guard items.count > currentTeamIndex else { return  nil }
        return items[currentTeamIndex]
    }
    
    func cancelButtonTapped() {
        router?.popToRoot()
    }
    
    func gameButtonTapped() {
        guard !isWin else {
            router?.popToRoot()
            return
        }
        guard let item = fetchedResultsController.fetchedObjects?[currentTeamIndex] else { return }
        router?.showCardGame(team: item)
    }
    
    func numberOfObject(in section: Int) -> Int{
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func getItem(at indexPath: IndexPath) -> Team {
        return fetchedResultsController.object(at: indexPath)
    }
}

extension GameHubPresenter: GameHubDelegate {
    func prepareNextTeam(count: Int) {
        guard let item = fetchedResultsController.fetchedObjects?[currentTeamIndex] else { return }
        item.points += Int16(count)
        if item.points < 0 {
            item.points = 0
        }
        if item.points >= winPoints {
            self.isWin = true
            view?.setTitleText(text: "Перемогла команда \"\(item.name ?? "none")\"")
        }
        currentTeamIndex += 1
        if currentTeamIndex == countTeam {
            currentTeamIndex = 0
        }
    }
    
}
