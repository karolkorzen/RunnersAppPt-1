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

protocol TrainingListControllerDelegate: class {
    func addTrainingToPost(withTrainingID training: String, withStats stats: Stats)
}

class TrainingsListController: UICollectionViewController {
    
    //MARK: - Properties
    
    let isAddTraining: Bool
    
    weak var addTrainingDelegate: TrainingListControllerDelegate?
    
    var viewModel = TrainingListViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Lifecycle
    
    init(withIsAdding bool: Bool){
        self.isAddTraining = bool
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        RunService.shared.fetchRuns { (dictionary)  in
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
        var array = Array(viewModel.dict)
        array.sort{ (training1, training2) -> Bool in
            training1.value.timestampStart>training2.value.timestampStart
        }
        cell.viewModel = TrainingViewModel(stats: array[indexPath.row].value, id: array[indexPath.row].key)
        //        cell.viewModel = TrainingViewModel(stats: Array(viewModel.dict)[indexPath.row].value, id: Array(viewModel.dict)[indexPath.row].key)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var array = Array(viewModel.dict)
        array.sort{ (training1, training2) -> Bool in
            training1.value.timestampStart>training2.value.timestampStart
        }
        if isAddTraining {
            addTrainingDelegate?.addTrainingToPost(withTrainingID: array[indexPath.row].key, withStats: array[indexPath.row].value)
            self.dismiss(animated: true, completion: nil)
        } else {
            let controller = RunSummaryController(withStats: array[indexPath.row].value, withDeleteEnabled: true, withTrainingUID: array[indexPath.row].key)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
        }
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
        RunService.shared.deleteRun(withTrainingID: id, completion: {
            self.fetchTrainings()
        })
    }
}
