//
//  StatsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 14/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import FloatingPanel

enum BarFilling {
    case notfilled
    case empty
    case almostfilled
    case filled
}

class StatsController: UIViewController {
    //MARK: - Properties
    
    private let viewModel = StatsSummaryViewModel()
    private let statsLabel = Utilities.shared.infoRunLabel()
    private var sceneTitle = UILabel()
    private var settingsIcon = Utilities.shared.actionButton(withSystemName: "gear")
    private var goal: Double = 10000.0 //FIXME: put vm here
    private var targetHeight: CGFloat = 0.0
    private var currentHeight: CGFloat = 0.0
    private var filling: BarFilling = .empty
    
    
    private let targetRect = UIView.init()
    private let currentRect = UIView.init()
    
    private let targetLine = UIView.init()
    private let currentLine = UIView.init()
    private let currentLineExt = UIView.init()

    private let targetTitleLabel = Utilities.shared.standardLabel(withSize: 12, withWeight: UIFont.Weight.light)
    private let currentTitleLabel = Utilities.shared.standardLabel(withSize: 12, withWeight: UIFont.Weight.light)
    
    private let targetLabel = Utilities.shared.standardLabel(withSize: 12, withWeight: UIFont.Weight.light)
    private let currentLabel = Utilities.shared.standardLabel(withSize: 12, withWeight: UIFont.Weight.light)
    
    private let avgRunTimeLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let maxRunTimeLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let avgDistanceLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let maxDistanceLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let avgSpeedLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let maxSpeedLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    
    var stackMain: UIStackView = UIStackView()
    
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
        targetHeight = self.view.frame.height/3
        let ratio = self.viewModel.statsSummary.wholeDistance / self.goal
        if ( ratio < 1.0 ) {
            if ( ratio < 0.8) {
                if (ratio == 0) {
                    filling = .empty
                }
                filling = .notfilled
            } else {
                filling = .almostfilled
            }
            currentHeight = CGFloat(ratio)*targetHeight
        } else {
            filling = .filled
            currentHeight = targetHeight
        }
        setFloatingPanel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        initialStatsBar()
        introAnimate()
        initialStatsLabels()
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
        sceneTitle.font = UIFont.boldSystemFont(ofSize: 33)
        sceneTitle.textColor = .appTintColor
        sceneTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 20)
        sceneTitle.setDimensions(width: view.frame.width-100, height: 50)
        sceneTitle.layer.zPosition = -1
        
        view.addSubview(settingsIcon)
        settingsIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingRight: 20)
        settingsIcon.backgroundColor = .white
        settingsIcon.tintColor = .appTintColor
        settingsIcon.setDimensions(width: 50, height: 50)
        settingsIcon.layer.zPosition = -1
    }
    
    func configStatsLabel (withUILabel label: UILabel) {
        label.tintColor = .appTintColor
        label.layer.zPosition = -1
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.numberOfLines = 2
    }
    
    func initialStatsLabels () {
        avgRunTimeLabel.text = viewModel.avgRunTimeLabelText
        maxRunTimeLabel.text = viewModel.maxRunTimeLabelText
        avgDistanceLabel.text = viewModel.avgDistanceLabelText
        maxDistanceLabel.text = viewModel.maxDistanceLabelText
        avgSpeedLabel.text = viewModel.avgSpeedLabelText
        maxSpeedLabel.text = viewModel.maxSpeedLabelText
        
        configStatsLabel(withUILabel: avgRunTimeLabel)
        configStatsLabel(withUILabel: maxRunTimeLabel)
        configStatsLabel(withUILabel: avgDistanceLabel)
        configStatsLabel(withUILabel: maxDistanceLabel)
        configStatsLabel(withUILabel: avgSpeedLabel)
        configStatsLabel(withUILabel: maxSpeedLabel)
        
        let stack1 = UIStackView(arrangedSubviews: [avgRunTimeLabel, maxRunTimeLabel])
        let stack2 = UIStackView(arrangedSubviews: [avgDistanceLabel, maxDistanceLabel])
        let stack3 = UIStackView(arrangedSubviews: [avgSpeedLabel, maxSpeedLabel])
        
        stackMain = UIStackView(arrangedSubviews: [stack1, stack2, stack3])
        
        stack1.axis = .horizontal
        stack2.axis = .horizontal
        stack3.axis = .horizontal
        stackMain.axis = .vertical
        
        stack1.distribution = .fillEqually
        stack2.distribution = .fillEqually
        stack3.distribution = .fillEqually
        stackMain.distribution = .fillEqually
        
        view.addSubview(stackMain)
        stackMain.layer.zPosition = -1
        stackMain.anchor(top: currentRect.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 60, paddingRight: 10)
        stackMain.alpha = 0.0
    }
    
    func initialStatsBar() {
        view.addSubview(targetRect)
        targetRect.layer.zPosition = -2
        targetRect.backgroundColor = .mainAppColor
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
        
        view.addSubview(targetLine)
        targetLine.layer.zPosition = -1
        targetLine.backgroundColor = .appTintColor
        targetLine.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/6, width: 1, height: 2)
        targetLine.layer.cornerRadius = 2
        targetLine.alpha = 0.0
        
        view.addSubview(currentLine)
        currentLine.layer.zPosition = -1
        currentLine.backgroundColor = .appTintColor
        switch filling {
        case .notfilled, .empty:
            currentLine.frame = CGRect(x: view.frame.width*10/20, y: self.view.frame.height/2-currentHeight, width: 1, height: 2)
        case .almostfilled, .filled:
            view.addSubview(currentLineExt)
            currentLineExt.layer.zPosition = -1
            currentLineExt.backgroundColor = .appTintColor
            currentLineExt.layer.cornerRadius = 2
            currentLineExt.alpha = 0.0
            currentLineExt.frame = CGRect(x: view.frame.width*10/20, y: self.view.frame.height/2-currentHeight, width: 2, height: 1)
            
            currentLine.frame = CGRect(x: view.frame.width*10/20, y: self.view.frame.height/4, width: 1, height: 2)
        }
        currentLine.layer.cornerRadius = 2
        currentLine.alpha = 0.0
        
        view.addSubview(targetLabel)
        targetLabel.layer.zPosition = -1
        targetLabel.text = "\(Int(goal)) m"
        targetLabel.textAlignment = .right
        targetLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/6, width: view.frame.width/3, height: 30)
        targetLabel.alpha = 0.0
        
        view.addSubview(currentLabel)
        currentLabel.layer.zPosition = -1
        currentLabel.text = "\(Int(viewModel.statsSummary.wholeDistance)) m" //FIXME: - set goal's vm here
        currentLabel.textAlignment = .right
        switch filling {
        case .notfilled, .empty:
            currentLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/2-currentHeight, width: view.frame.width/3, height: 30)
        case .almostfilled, .filled:
            currentLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/4, width: view.frame.width/3, height: 30)
        }
        currentLabel.alpha = 0.0
        
        view.addSubview(targetTitleLabel)
        targetTitleLabel.layer.zPosition = -1
        targetTitleLabel.text = "Your Goal:"
        targetTitleLabel.textAlignment = .right
        targetTitleLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/6-30, width: view.frame.width/3, height: 30)
        targetTitleLabel.alpha = 0.0
        
        view.addSubview(currentTitleLabel)
        currentTitleLabel.layer.zPosition = -1
        currentTitleLabel.text = "You've Run:"
        currentTitleLabel.textAlignment = .right
        switch filling {
        case .notfilled, .empty:
            currentTitleLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/2-currentHeight-30, width: view.frame.width/3, height: 30)
        case .almostfilled, .filled:
            currentTitleLabel.frame = CGRect(x: view.frame.width*10/20, y: view.frame.height/4-30, width: view.frame.width/3, height: 30)
        }
        currentTitleLabel.alpha = 0.0
    }
    
    func animateBarTarget() {
        self.targetRect.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height/2-self.targetHeight, width: self.view.frame.width/5, height: self.targetHeight)
        self.targetRect.layer.cornerRadius = 10
        self.targetRect.alpha = 0.8
    }
    
    func animateBarCurrent() {
        self.currentRect.frame = CGRect(x: self.view.frame.width/4, y: self.view.frame.height/2-self.currentHeight, width: self.view.frame.width/5, height: self.currentHeight)
        self.currentRect.layer.cornerRadius = 10
        self.currentRect.alpha = 1.0
    }
    
    func animateLines() {
        self.targetLine.frame = CGRect(x: self.view.frame.width*10/20, y: self.view.frame.height/6, width: self.view.frame.width/3, height: 2)
        self.targetLine.layer.cornerRadius = 2
        self.targetLine.alpha = 1.0

        switch filling {
        case .notfilled, .empty:
            self.currentLine.frame = CGRect(x: self.view.frame.width*10/20, y: self.view.frame.height/2-self.currentHeight, width: self.view.frame.width/3, height: 2)
            break
        case .almostfilled, .filled:
            self.currentLine.frame = CGRect(x: self.view.frame.width*10/20, y: self.view.frame.height/4, width: self.view.frame.width/3, height: 2)
            break
        }
        
        self.currentLine.layer.cornerRadius = 2
        self.currentLine.alpha = 1.0
    }
    
    func animateLabels(){
        self.targetLabel.alpha = 1.0
        self.currentLabel.alpha = 1.0
        self.currentTitleLabel.alpha = 1.0
        self.targetTitleLabel.alpha = 1.0
    }
    
    func animateStatsLabels(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
            self.stackMain.alpha = 1.0
        }
    }
    
    func introAnimate() {
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut) {
            self.animateBarTarget()
            self.animateBarCurrent()
        } completion: { (bool) in
            switch self.filling {
                case .notfilled, .empty:
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                        self.animateLines()
                    }
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                        self.animateLabels()
                    } completion: { (bool) in
                        self.animateStatsLabels()
                    }
                case .almostfilled, .filled:
                    UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear) {
                        let tmp = self.view.frame.height/2-self.currentHeight
                        self.currentLineExt.frame = CGRect(x: self.view.frame.width*10/20, y: self.view.frame.height/2-self.currentHeight, width: 2, height: self.currentLine.frame.maxY-tmp)
                        self.currentLineExt.alpha = 1.0
                    } completion: { (bool) in
                        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                            self.animateLines()
                        }
                        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                            self.animateLabels()
                        } completion: { (bool) in
                            self.animateStatsLabels()
                        }
                    }
            }
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
