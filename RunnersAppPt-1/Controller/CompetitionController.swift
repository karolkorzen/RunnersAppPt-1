//
//  CompetitionController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 07/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "TrainingCell"
private let headerIdentifier = "HeaderCell"

class CompetitionController: UICollectionViewController {
    // MARK: - Properties
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAppColor
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y:0, width: 64, height: 32)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(deleteCompetition), for: .touchUpInside)
        return button
    }()
    
    let isInvite: Bool
    var competition: Competition {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.mainAppColor, for: .normal)
        button.backgroundColor = .white
        button.setDimensions(width: 36, height: 36)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainAppColor.cgColor
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.mainAppColor, for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainAppColor.cgColor
        button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        return button
    }()
    
    
    init(withCompetition competition: Competition, isInvite bool: Bool) {
        self.isInvite = bool
        self.competition = competition
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
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    //MARK: - Selectors
    
    @objc func deleteCompetition(){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        CompetitionsService.shared.deleteUserCompetition(withCompetitonID: competition.id, withUserID: currentUID)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAccept(){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        CompetitionsService.shared.addUserCompetiton(withCompetitonID: competition.id, withUserID: currentUID, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func handleReject(){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        CompetitionsService.shared.deleteUserInvited(withCompetitonID: competition.id, withUserID: currentUID, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(CompetitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(CompetitionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.isUserInteractionEnabled = true
    }
}
    
//MARK: - UICollectionViewDelegate

extension CompetitionController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: conunt \(competition.competitors.count)")
        return competition.competitors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CompetitionCell 
        cell.delegate = self
        cell.user = competition.competitors[indexPath.row]
        RunService.shared.fetchStatsForUser(withUID: competition.competitors[indexPath.row].uid) { (stats) in
            var tmp = 0.0
            for value in stats {
                if (value.timestampStart>=self.competition.startDate.timeIntervalSince1970 && value.timestampStop<=self.competition.stopDate.timeIntervalSince1970) {
                    tmp += value.distance
                }
            }
            cell.distance = tmp
            if tmp>self.competition.distance {
                cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            }
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CompetitionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CompetitionHeaderView
        header.competition = self.competition
        return header
    }
}

extension CompetitionController: CompetitionCellDelegate{
    func presentProfile(withUser user: User) {
        let view = ProfileController(user: user)
        navigationController?.pushViewController(view, animated: true)
    }
}
