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
            print("DEBUG: fetched in statsController")
            print(dictionary)
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(TrainingMonthCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.reloadData()
    }
}

////MARK: - UICollectionViewDelegate/DataSource
//
//extension StatsController {
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrainingMonthCell
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
