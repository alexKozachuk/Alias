//
//  CardGameViewController.swift
//  Alias
//
//  Created by Sasha on 18/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol CardGameDelegate {
    func popToRootViewController(animated: Bool)
    func popViewController(animated: Bool)
}

class CardGameViewController: UIViewController{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxCountLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    let shapeLayer = CAShapeLayer()
    var timer : Timer!
    let maxCount = 10
    var count: Int = 0
    var dataSource: [String] = ["Духовка", "Чашка", "Друг", "Пульт", "Легіонер", "Зарядка", "Любов"]
    var answers: [Answer] = []
    var isStart: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
    }
    
    func configureTimer() {
        count = self.maxCount
        let center = CGPoint(x: timeLabel.frame.width / 2, y: timeLabel.frame.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 4
        
        shapeLayer.strokeEnd = 1
        
        timeLabel.layer.addSublayer(shapeLayer)
        
    }
    
    private func startTimer() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.toValue = UIColor.red.cgColor
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [basicAnimation, colorAnimation]
        groupAnimation.duration = CFTimeInterval(maxCount)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(groupAnimation, forKey: "urSoBasic")
        
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func update() {
        if(count > 0) {
            count -= 1
            timeLabel.text = String(count)
        } else {
            count = maxCount
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
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func plusButtonTapped() {
        guard isStart else {
            isStart.toggle()
            startTimer()
            return
        }
        guard let word = cardView.nameLabel.text else { return }
        let answer = Answer(name: word, isAnswered: true)
        answers.append(answer)
        rollNextCard()
    }
    
    @IBAction func minusButtonTapped() {
        guard isStart else {
            isStart.toggle()
            startTimer()
            return
        }
        guard let word = cardView.nameLabel.text else { return }
        let answer = Answer(name: word, isAnswered: false)
        answers.append(answer)
        rollNextCard()
        /*let vc = ResultViewController.instantiate(from: .main)
        navigationController?.pushViewController(vc, animated: true)*/
    }
    
    func rollNextCard() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cardView.alpha = 0
        }) { _ in
            self.cardView.nameLabel.text = self.dataSource.randomElement() ?? "nil"
            UIView.animate(withDuration: 0.5, animations: {
                self.cardView.alpha = 1
            }) { _ in
                
            }
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
}
