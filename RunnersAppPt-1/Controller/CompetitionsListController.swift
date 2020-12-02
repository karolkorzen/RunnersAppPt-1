//
//  CompletitonsListController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 30/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let tableReuseIdentifier = "tblid"

class CompetitionsListController: UITableViewController {
    
    //MARK: - Properties
    
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
        configureView()
        configureRightBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Competitions"
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
//        tableView.separatorStyle = .none
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //tableData[indexPath.section].modelname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(section)
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
}
