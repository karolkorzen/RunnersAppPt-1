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
    private var sceneTitle = UILabel()
    private var settingsIcon = Utilities.shared.actionButton(withSystemName: "gear")
    
    
    private let targetRect = UIView.init()
    private let currentRect = UIView.init()
    
    let fpc = FloatingPanelController()
    
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
        initialStats()
        introAnimate()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    //MARK: - Helpers
    
    func setFloatingPanel() {
        fpc.delegate = self
        let trainingListController = TrainingsListController(collectionViewLayout: UICollectionViewFlowLayout())
        fpc.set(contentViewController: trainingListController)
        fpc.track(scrollView: trainingListController.collectionView)
        fpc.layout = MyStatsFloatingPanelLayout()
        fpc.addPanel(toParent: self)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(sceneTitle)
        sceneTitle.text = "Your scores"
        sceneTitle.font = UIFont.boldSystemFont(ofSize: 26)
        sceneTitle.textColor = .appTintColor
        sceneTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 30)
        sceneTitle.setDimensions(width: view.frame.width/2-20, height: 50)
        
        view.addSubview(settingsIcon)
        settingsIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 30, paddingRight: 30)
        settingsIcon.backgroundColor = .white
        settingsIcon.tintColor = .appTintColor
        settingsIcon.setDimensions(width: 50, height: 50)
    }
    
    func initialStats() {
        view.addSubview(targetRect)
        targetRect.layer.zPosition = -2
        targetRect.backgroundColor = .lightGray
        let initialHeight = view.frame.height/30
        targetRect.frame = CGRect(x: view.frame.width/4, y: view.frame.height/2-initialHeight, width: view.frame.width/5, height: initialHeight)
        targetRect.layer.cornerRadius = 10
        targetRect.alpha = 0.8
        
        view.addSubview(currentRect)
        currentRect.layer.zPosition = -1
        currentRect.backgroundColor = UIColor(red: 0.906, green: 0.784, blue: 0.573, alpha: 1.000)
        currentRect.frame = CGRect(x: view.frame.width/4, y: view.frame.height/2-initialHeight, width: view.frame.width/5, height: initialHeight)
        currentRect.layer.cornerRadius = 10
        currentRect.alpha = 0.8
    }
    
    func introAnimate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut) {
            let targetHeight = self.view.frame.height/3
            self.targetRect.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height/2-targetHeight, width: self.view.frame.width/5, height: targetHeight)
            self.targetRect.layer.cornerRadius = 10
            self.targetRect.alpha = 0.8
            
            let currentHeight = CGFloat((self.viewModel.statsSummary.wholeDistance / 1000.0))*self.view.frame.height/30 //FIXME: - TARGET DISTANCE HEREs
            self.currentRect.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height/2-currentHeight, width: self.view.frame.width/5, height: currentHeight)
            self.currentRect.layer.cornerRadius = 10
            self.currentRect.alpha = 1.0
            
        } completion: { (bool) in
            print("done")
        }

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
