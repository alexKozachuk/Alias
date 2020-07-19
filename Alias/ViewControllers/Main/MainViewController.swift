//
//  ViewController.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    
    private let dataSource = TeamStoarge.shared.teams
    private let itemsPerRow: CGFloat = 2
    private let itemsPerScreen: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSelection()
        navigationController?.navigationBar.isHidden = true
    }

    func setupCollectionView() {
        self.collectionView.register(type: TeamCollectionViewCell.self)
        self.collectionView.allowsMultipleSelection = true
    }
    
    func setupSelection() {
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .top)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any?) {
        
    }
    
    @IBAction func continueButtonTapped(_ sender: Any?) {
        guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
        guard indexPaths.count >= 2 else { return }
        
        let items = indexPaths.map {
            return dataSource[$0.item]
        }
        
        
        let vc = GameHubViewController.instantiate(from: .main)
        vc.setup(dataSource: items)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSelection()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        checkSelection()
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
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.row]
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
