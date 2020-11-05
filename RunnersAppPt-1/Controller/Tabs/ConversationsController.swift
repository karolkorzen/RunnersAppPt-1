//
//  ConversationsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 08/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class ConversationsController: UIViewController {
    // MARK: - Properties
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers

    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
