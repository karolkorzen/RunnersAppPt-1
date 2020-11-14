//
//  StatsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 06/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Training cell"

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
        DispatchQueue.main.async {
            self.configureUI()
        }
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
        print("Show training details for \(Array(viewModel.dict)[indexPath.row].key)")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TrainingsListController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/3)-10, height: view.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
