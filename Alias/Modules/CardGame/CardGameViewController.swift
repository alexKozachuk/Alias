//
//  CardGameViewController.swift
//  Alias
//
//  Created by Sasha on 18/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

class CardGameViewController: UIViewController{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxCountLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    @IBInspectable var rightAnswerColor: UIColor!
    @IBInspectable var wrongAnswerColor: UIColor!
    @IBInspectable var defaultColor: UIColor!
    
    let shapeLayer = CAShapeLayer()
    var presenter: CardGamePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        cardView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        configureTimer()
    }
    
    func configureTimer() {
        let center = CGPoint(x: timeLabel.frame.width / 2, y: timeLabel.frame.height / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 20, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = self.rightAnswerColor.cgColor
        shapeLayer.lineWidth = 4
        
        shapeLayer.strokeEnd = 1
        
        timeLabel.layer.addSublayer(shapeLayer)
        
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any?) {
        presenter.pauseButtonTapped()
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
            guard let text = self.cardView.nameLabel.text else { return }
            self.presenter.cardSwiped(text: text, isPositive: isPositive)
            self.cardView.transform = .identity
            self.cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.cardView.backgroundColor = self.defaultColor
            
            UIView.animate(withDuration: 0.2) {
                self.cardView.layer.opacity = 1.0
                self.cardView.transform = .identity
            }
        }
        
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        switch gesture.state {
        case .began:
            break
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

extension CardGameViewController: CardGameViewProtocol {
    
    func pauseTimer() {
         shapeLayer.pause()
    }
    
    func resumeTimer() {
        shapeLayer.resume()
    }
    
    func setCurrentCountLabel(text: String?) {
        self.currentCountLabel.text = text
    }
    
    func setMaxCountLabelLabel(text: String?) {
        self.maxCountLabel.text = text
    }
    
    func setTimeLabelLabel(text: String?) {
        self.timeLabel.text = text
    }
    
    func setCardNameLabel(text: String?) {
        self.cardView.nameLabel.text = text
    }
    
    func startTimer(with duration: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.toValue = self.wrongAnswerColor.cgColor
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [basicAnimation, colorAnimation]
        groupAnimation.duration = CFTimeInterval(duration)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(groupAnimation, forKey: "urSoBasic")
    }
    
    
}
