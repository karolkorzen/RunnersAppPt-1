//
//  CompletitonsListController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 30/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import Firebase

private let tableReuseIdentifier = "tblid"

class CompetitionsListController: UITableViewController {
    
    //MARK: - Properties
    
    private var competitionsTable:[Competition] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    private var invitesTable:[Competition] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAppColor
        button.setTitle("New", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y:0, width: 64, height: 32)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(addCompetitonsTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureView()
        configureRightBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Competitions"
        tableView.reloadData()
    }
    
    // MARK: - API
    func fetchData() {
        CompetitionsService.shared.fetchCompetitions { (competitions) -> (Void) in
//            print("DEBUG: competitions \(competitions)")
            self.competitionsTable = competitions
        }
        CompetitionsService.shared.fetchInvites { (competitions) -> (Void) in
//            print("DEBUG: competitions \(competitions)")
            self.invitesTable = competitions
        }
    }
    
    //MARK: - Selectors
    
    @objc func addCompetitonsTapped(){
        print("DEBUG: navbarAddCompetitions")
        let view = InviteController()
        view.modalPresentationStyle = .formSheet
        present(view, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureView(){
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(CompetitionsListCell.self, forCellReuseIdentifier: tableReuseIdentifier)
        tableView.rowHeight = 60
    }
    
    func configureRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

extension CompetitionsListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableData[section].data
//        if section == 1 { ... }
        if section == 0 {
            return invitesTable.count
        } else {
            return competitionsTable.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentifier) as! CompetitionsListCell
        cell.delegate = self
        //tableData[indexPath.section].modelname
        
        if indexPath.section == 0 {
            cell.competition = invitesTable[indexPath.row]
            cell.isInvitation = true
            return cell
        } else {
            cell.competition = competitionsTable[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Invites"
        } else {
            return "Your Competitions"
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = CompetitionController(withCompetition: competitionsTable[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension CompetitionsListController: CompetitionsListCellDelegate {
    func acceptInvite(withID id: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        CompetitionsService.shared.addUserCompetiton(withCompetitonID: id, withUserID: currentUID, completion: {
            for (index,value) in self.invitesTable.enumerated() {
                if value.id == id {
                    self.invitesTable.remove(at: index)
                }
            }
        })
    }
    
    func rejectInvite(withID id: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        CompetitionsService.shared.deleteUserInvited(withCompetitonID: id, withUserID: currentUID, completion: {
            for (index,value) in self.invitesTable.enumerated() {
                if value.id == id {
                    self.invitesTable.remove(at: index)
                }
            }
        })
        
    }
}
