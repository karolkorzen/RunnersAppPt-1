//
//  StatsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 14/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import FloatingPanel

class StatsController: UIViewController {
    //MARK: - Properties
    

    
    //MARK: - Lifecycle
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Helpers
    
    func setFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        let trainingListController = TrainingsListController(collectionViewLayout: UICollectionViewFlowLayout())
        fpc.set(contentViewController: trainingListController)
        fpc.track(scrollView: trainingListController.collectionView)
        fpc.addPanel(toParent: self)
        
        
        
    }
}

extension StatsController: FloatingPanelControllerDelegate {
    
}
