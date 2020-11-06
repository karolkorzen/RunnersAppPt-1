//
//  NewMessageController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 28/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class NewMessageController: UITableViewController{
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
}
