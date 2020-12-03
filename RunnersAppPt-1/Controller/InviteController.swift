//
//  InviteController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 01/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

let reusableCell = "reuseid"

class InviteController: UITableViewController {
    
    //MARK: - Properties
    
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
//    private var filteredUsers = [User]() {
//        didSet{
//            tableView.reloadData()
//        }
//    }
    
    private var selectedUsersCount: Int = 0 {
        didSet {
            let header = tableView.tableHeaderView as! AddCompetitionsHeader
            header.selectedUsersCount = selectedUsersCount
        }
    }
    private var selectedUsers: [Int : String] = [:]
//    private var searchText: String = ""
    
//    private var inSearchMode: Bool {
//        return !searchText.isEmpty
//    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configureUI()
        fetchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchUsers(){
        UserService.shared.fetchUsers { (users) in
            self.users = users
        }
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    
    func configUI() {
        let header = AddCompetitionsHeader(frame: CGRect.init(x: 0, y: 0, width: accessibilityFrame.width, height: 370))
        header.delegate = self
        tableView.tableHeaderView = header
    }
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reusableCell)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension InviteController {
    
    //FIXME: - ADD SERCIOTN FOR SELECTED
    //FIXME: - MOVE VIEW TO MAKE LABEL INVITE PEOPLE ON TOP
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell) as! UserCell
        //cell.user = users[indexPath.row]
//        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return inSearchMode ? filteredUsers.count : users.count
        users.count
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        if tableView.cellForRow(at: indexPath)?.contentView.backgroundColor == .cellBackground {
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = nil
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            selectedUsersCount -= 1
            selectedUsers.removeValue(forKey: indexPath.row)
        } else {
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .cellBackground
            tableView.cellForRow(at: indexPath)?.contentView.layer.cornerRadius = 10
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            selectedUsersCount += 1
            let cell = tableView.cellForRow(at: indexPath) as! UserCell
            selectedUsers[indexPath.row] = cell.user?.uid
        }
    }
}

extension InviteController: AddCompetitionsHeaderDelegate {
    func createCompetition() {
        let header = tableView.tableHeaderView as! AddCompetitionsHeader
        let headerIngredients = header.createIngredients
        print("DEBUG: header ingredients -> \(headerIngredients)")
        print("DEBUG: fetching selected users")
        CompetitionsService.shared.fetchCompetition(withCompetitionHeaderModel: headerIngredients, withUsers: Array(selectedUsers.values) as! Array, completion: {})
        self.dismiss(animated: true, completion: nil)
    }
}
