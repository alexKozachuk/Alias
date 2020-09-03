//
//  ViewController.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UIViewController

class MainViewController: UIViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    
    private let itemsPerRow: CGFloat = 2
    private let itemsPerScreen: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    var presenter: MainViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func setupCollectionView() {
        self.collectionView.register(type: TeamCollectionViewCell.self)
        self.collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - IBActions
    
    @IBAction func settingsButtonTapped(_ sender: Any?) {
        presenter.settingsButtonTapped()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any?) {
        presenter.continueButtonTapped()
    }
    
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func selectItemAtIndexPath(indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
    
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSelection()
        presenter.itemDidSelect(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        checkSelection()
        presenter.itemDidDeselect(at: indexPath)
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
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowAnimatedContent, animations: {
            let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            cell.contentView.transform = transform
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn, animations: {
            cell.contentView.transform = .identity
        })
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfObject(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.getItem(at: indexPath)
        let cell = collectionView.dequeueReusableCell(with: TeamCollectionViewCell.self, for: indexPath)
        cell.setup(team: item, delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width
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

// MARK: - TeamCollectionViewCellDelegate

extension MainViewController: TeamCollectionViewCellDelegate {
    
    func editButtonTapped(team: Team) {
//        let vc = EditTeamViewController.instantiate(from: .main)
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.setup(team: team, delegate: self)
//        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - EditTeamViewControllerDelegate

extension MainViewController: EditTeamViewControllerDelegate {
    
    func didSave() {
        collectionView.reloadData()
        presenter.checkSelection()
    }
    
}
