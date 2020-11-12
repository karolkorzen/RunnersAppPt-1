//
//  StatsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 06/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Training cell"

class StatsController: UICollectionViewController {
    // MARK: - Lifecycle
    
    var viewModel: TrainingListViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureUI()
            self.fetchTrainings()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchTrainings(){
        RunService.shared.fetchRuns { (dictionary) in
            let vm = TrainingListViewModel(dict: dictionary)
            self.viewModel = TrainingListViewModel(dict: dictionary)
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .green
    }
}

//MARK: - UICollectionViewDelegate/DataSource

//extension StatsController {
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return viewModel?.numberOfTrainings ?? 9
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) //as! MonthCell
//        cell.backgroundColor = .init(red: 80, green: 0, blue: 0, alpha: 0.6)
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("DEBUG: expand month!")
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout
//
//extension StatsController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width-12, height: view.frame.height/10)
//    }
//}
