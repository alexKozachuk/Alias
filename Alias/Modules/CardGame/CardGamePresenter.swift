//
//  CardGamePresenter.swift
//  Alias
//
//  Created by Sasha on 25/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreData
import Foundation

class CardGamePresenter: CardGamePresenterProtocol {
    
    weak var view: CardGameViewProtocol?
    var coreDataService: CoreDataService!
    var router: RouterProtocol?
    
    var delegate: GameHubDelegate!
    var currentTeam: Team!
    var timer : Timer!
    var maxCount = 30
    var count = 0.0
    var isPenalty = true
    
    var answers: [Answer] = []
    var isStart: Bool = false
    
    var fetchedResultsController: NSFetchedResultsController<Card>!
    
    var currentPoints: Int = 0 {
        didSet {
            view?.setCurrentCountLabel(text: String(currentPoints))
        }
    }
    
    required init(view: CardGameViewProtocol, coreDataService: CoreDataService, router: RouterProtocol, team: Team) {
        self.view = view
        self.coreDataService = coreDataService
        self.router = router
        self.currentTeam = team
    }
    
    func viewDidLoad() {
        prepareDefaults()
        setupGame()
        setupFetchRequest()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        count = Double(maxCount)
//        configureTimer()
    }
    
    func prepareDefaults() {
        let defaults = UserDefaultsManager.share
        let timeRound = defaults.getInt(key: .timeRound)
        let winPoint = defaults.getInt(key: .winPoints)
        let penalty = defaults.getBool(key: .penalty)
        isPenalty = penalty
        maxCount = timeRound
        view?.setMaxCountLabelLabel(text: "/\(winPoint)")
        view?.setTimeLabelLabel(text: "\(timeRound)")
    }
    

    func setupGame() {
        currentPoints = Int(currentTeam.points)
    }
    
    func setupFetchRequest() {
        let fetchRequest = CardDeck.getSelectedCardDeck()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        guard let item = fetchedResultsController.fetchedObjects?.first else { return }
        
        let secondFetchRequest = Card.fetchRequest(cardDeck: item)
        let seconfFetchedResultsController = NSFetchedResultsController(fetchRequest: secondFetchRequest, managedObjectContext: CoreDataManager.share.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController = seconfFetchedResultsController
    }
    
    
    
    private func startTimer() {
        view?.startTimer(with: Double(maxCount))
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        view?.pauseTimer()
        timer?.invalidate()
    }

    @objc func update() {
        if(count > 0) {
            count -= 0.1
            view?.setTimeLabelLabel(text: String(Int(count)))
        } else {
            count = Double(maxCount)
            pauseTimer()
            router?.showResult(team: currentTeam, dataSource: answers)
        }
    }
    
    func cardSwiped(text: String, isPositive: Bool) {
        guard let item = self.fetchedResultsController.fetchedObjects?.randomElement() else { return }
        view?.setCardNameLabel(text: item.name)
        
        guard isStart else {
            isStart.toggle()
            startTimer()
            return
        }
        
        
        if isPositive {
            currentPoints += 1
            let answer = Answer(name: text, isAnswered: true)
            answers.append(answer)
        } else {
            let answer = Answer(name: text, isAnswered: false)
            answers.append(answer)
            if isPenalty {
                currentPoints -= 1
            }
        }
    }
    
    func pauseButtonTapped() {
        pauseTimer()
        view?.pauseTimer()
        router?.presentPauseMenu(delegate: self)
    }
}

extension CardGamePresenter: CardGameDelegate {
    func popToRootViewController(animated: Bool = false) {
        //navigationController?.popToRootViewController(animated: animated)
    }
    
    func popViewController(animated: Bool = false) {
        //navigationController?.popViewController(animated: animated)
    }
    
    func popViewControllerWithCount(animated: Bool, count: Int) {
        //delegate.prepareNextTeam(count: count)
        //navigationController?.popViewController(animated: animated)
    }
    
    func resume() {
        view?.resumeTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}
