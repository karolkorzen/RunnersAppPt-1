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
    
    private let viewModel = StatsSummaryViewModel()
    private let statsLabel = Utilities.shared.infoRunLabel()
    
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
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - Helpers
    
    func setFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        let trainingListController = TrainingsListController(collectionViewLayout: UICollectionViewFlowLayout())
        fpc.set(contentViewController: trainingListController)
        fpc.track(scrollView: trainingListController.collectionView)
        fpc.layout = MyStatsFloatingPanelLayout()
        
        fpc.addPanel(toParent: self)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(statsLabel)
        statsLabel.layer.zPosition = CGFloat(-(Float.greatestFiniteMagnitude))
        statsLabel.text = viewModel.testLabel
        statsLabel.setDimensions(width: view.frame.width - 20, height: 300)
        statsLabel.font = UIFont.italicSystemFont(ofSize: 10)
        statsLabel.center(inView: self.view)
    }
}

extension StatsController: FloatingPanelControllerDelegate {
}

class MyStatsFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
