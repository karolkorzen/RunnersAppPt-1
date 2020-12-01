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
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    
    func configUI() {
        tableView.tableHeaderView = AddCompetitionsHeader(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height/4))
    }
    
}

extension InviteController {
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //FIXME: - user cell from searchController
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //FIXME: - number of users you follow
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //FIXME: - highlight that its selected
//    }
}
