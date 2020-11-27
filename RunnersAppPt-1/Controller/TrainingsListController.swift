//
//  StatsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 06/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TrainingCell"
private let headerIdentifier = "HeaderCell"

class TrainingsListController: UICollectionViewController {
    // MARK: - Lifecycle
    
    var viewModel = TrainingListViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchTrainings()
        }
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchTrainings(){
        RunService.shared.fetchRuns { (dictionary) in
            self.viewModel = TrainingListViewModel(dict: dictionary)
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(TrainingListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TrainingListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate

extension TrainingsListController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfTrainings
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrainingListCell
        cell.viewModel = TrainingViewModel(stats: Array(viewModel.dict)[indexPath.row].value, id: Array(viewModel.dict)[indexPath.row].key)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = RunSummaryController(withStats: Array(viewModel.dict)[indexPath.row].value, withDeleteEnabled: true, withTrainingUID: Array(viewModel.dict)[indexPath.row].key)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TrainingsListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/3)-10, height: view.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! TrainingListHeader
        return header
    }
    
}

extension TrainingsListController: RunSummaryControllerDelegate {
    func deleteTraining(withTrainingUID id: String) {
        RunService.shared.deleteRun(withTrainingID: id)
        self.fetchTrainings()
        print("DEBUG: deleted training")
    }
    

}
