//
//  CardGameViewController.swift
//  Alias
//
//  Created by Sasha on 18/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

// Change with DB
protocol CardGameDelegate {
    func popToRootViewController(animated: Bool)
    func popViewController(animated: Bool)
    func popViewControllerWithCount(animated: Bool, count: Int)
    func resume()
}

class CardGameViewController: UIViewController{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxCountLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    @IBInspectable var rightAnswerColor: UIColor!
    @IBInspectable var wrongAnswerColor: UIColor!
    @IBInspectable var defaultColor: UIColor!
    
    var delegate: GameHubDelegate!
    var currentTeam: Team!
    let shapeLayer = CAShapeLayer()
    var timer : Timer!
    var maxCount = 30
    var count = 0.0
    var isPenalty = true
    
    var fetchedResultsController: NSFetchedResultsController<Card>!
    
    var answers: [Answer] = []
    var isStart: Bool = false
    
    var currentPoints: Int = 0 {
        didSet {
            currentCountLabel.text = String(currentPoints)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDefaults()
        setupGame()
        setupFetchRequest()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        configureTimer()
        cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    func prepareDefaults() {
        let defaults = UserDefaultsManager.share
        let timeRound = defaults.getInt(key: .timeRound)
        let winPoint = defaults.getInt(key: .winPoints)
        let penalty = defaults.getBool(key: .penalty)
        isPenalty = penalty
        maxCount = timeRound
        maxCountLabel.text = "/\(winPoint)"
        timeLabel.text = "\(timeRound)"
    }
    
    func setup(team: Team) {
        self.currentTeam = team
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
    
    func configureTimer() {
        count = Double(self.maxCount)
        let center = CGPoint(x: timeLabel.frame.width / 2, y: timeLabel.frame.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = self.rightAnswerColor.cgColor
        shapeLayer.lineWidth = 4
        
        shapeLayer.strokeEnd = 1
        
        timeLabel.layer.addSublayer(shapeLayer)
        
    }
    
    private func startTimer() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.toValue = self.wrongAnswerColor.cgColor
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [basicAnimation, colorAnimation]
        groupAnimation.duration = CFTimeInterval(maxCount)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(groupAnimation, forKey: "urSoBasic")
        
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func pauseTimer() {
        shapeLayer.pause()
        timer?.invalidate()
    }

    @objc func update() {
        if(count > 0) {
            count -= 0.1
            timeLabel.text = String(Int(count))
        } else {
            count = Double(maxCount)
            stopTimer()
            let vc = ResultViewController.instantiate(from: .main)
            vc.dataSource = answers
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any?) {
        let vc = PauseMenuViewController.instantiate(from: .main)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        pauseTimer()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func plusButtonTapped() {
        swipeCard(isPositive: true)
    }
    
    @IBAction func minusButtonTapped() {
        swipeCard(isPositive: false)
    }
    
    func swipeCard(isPositive: Bool) {
        let multipler = isPositive ? 1.0 : -1.0
        
        
        UIView.animate(withDuration: 0.3, animations: {
            let translationX = CGFloat(500.0 * multipler)
            let rotate = CGFloat(0.7 * multipler)
            let transform = CGAffineTransform(translationX: translationX, y: 0)
            self.cardView.transform = transform.rotated(by: rotate)
            self.cardView.layer.opacity = 0.0
            self.cardView.backgroundColor = isPositive ? self.rightAnswerColor : self.wrongAnswerColor
        }) { _ in
            self.rollNextCard(isPositive: isPositive)
            self.cardView.transform = .identity
            self.cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.cardView.backgroundColor = self.defaultColor
            
            UIView.animate(withDuration: 0.2) {
                self.cardView.layer.opacity = 1.0
                self.cardView.transform = .identity
            }
        }
        
    }
    
    
    func rollNextCard(isPositive: Bool) {
  
        guard let word = cardView.nameLabel.text else { return }
        guard let item = self.fetchedResultsController.fetchedObjects?.randomElement() else { return }
        self.cardView.nameLabel.text = item.name
        
        
        guard isStart else {
            isStart.toggle()
            startTimer()
            return
        }
        
        
        if isPositive {
            currentPoints += 1
            let answer = Answer(name: word, isAnswered: true)
            answers.append(answer)
        } else {
            let answer = Answer(name: word, isAnswered: false)
            answers.append(answer)
            if isPenalty {
                currentPoints -= 1
            }
        }
        
        
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        switch gesture.state {
        case .began:
            print("begin")
        case .changed:
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y / 10)
            var rotate = translation.x / 180
            if rotate > 0.5 {
                rotate = 0.5
            } else if rotate < -0.5 {
                rotate = -0.5
            }
            print(rotate)
            cardView.transform = transform.rotated(by: rotate)
        case .ended:
            if translation.x > 60 {
                swipeCard(isPositive: true)
            } else if translation.x < -60 {
                swipeCard(isPositive: false)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.cardView.transform = .identity
                }, completion: nil)
            }
        default: break
            
        }
    }
}

extension CardGameViewController: CardGameDelegate {
    func popToRootViewController(animated: Bool = false) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func popViewController(animated: Bool = false) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popViewControllerWithCount(animated: Bool, count: Int) {
        delegate.prepareNextTeam(count: count)
        navigationController?.popViewController(animated: animated)
    }
    
    func resume() {
        shapeLayer.resume()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}

