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
        //navigationController?.title = "Competitions"
        navigationItem.title = "Competitions"
    }
    
    //MARK: - Selectors
    
    @objc func addCompetitonsTapped(){
        print("DEBUG: navbarAddCompetitions")
    }
    
    //MARK: - Helpers
    
    func configureView(){
        view.backgroundColor = .white
//        tableView.separatorStyle = .none
    }
    
    func configureRightBarButton(){
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.setDimensions(width: 25, height: 25)
        let tap = UITapGestureRecognizer(target: self, action: #selector(addCompetitonsTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: image)
        navigationItem.rightBarButtonItem?.tintColor = .mainAppColor
        
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

extension CompetitionsListController: CompetitionsListHeaderDelegate {
    func addCompetitionHeader() {
        print("DEBUG: show add competiton view")
    }
}
