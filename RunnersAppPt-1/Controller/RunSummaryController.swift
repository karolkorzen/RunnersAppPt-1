//
//  RunSummaryController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 04/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import MapKit
import Charts

class RunSummaryController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RunSummaryViewModel()
    
    private var mapView = MKMapView()
    var mapViewZoomed: Bool = false
    
    private let timeLabel = Utilities.shared.standardLabel(withSize: 15, withWeight: .semibold)
    private let distanceLabel = Utilities.shared.standardLabel(withSize: 15, withWeight: .semibold)
    private let minAltitudeLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let maxAltitudeLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let avgSpeedLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    private let maxSpeedLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .semibold)
    
    //MARK: - Lifecycle
    
    init(withStats stats: Stats) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = RunSummaryViewModel(withStats: stats)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMapView()
        configureStatsLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Selectors
    
    @objc func mapViewTapped(){
        print("DEBUG: tapped")
        if mapViewZoomed {
            restoreMapView()
        } else {
            zoomMapView()
        }
        mapViewZoomed.toggle()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm"
        navigationItem.title = formatter.string(from: Date(timeIntervalSince1970: viewModel.stats.timestampStart))
    }
    
    func configStatsLabel(withUILabel label: UILabel) {
        label.tintColor = .appTintColor
        label.layer.zPosition = -1
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .cellBackground
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.alpha = 1.0
    }
    
    func configureStatsLabels() {
        timeLabel.text = viewModel.timeLabelText
        distanceLabel.text = viewModel.distanceLabelText
        maxAltitudeLabel.text = viewModel.minAltitudeLabelText
        maxAltitudeLabel.text = viewModel.maxAltitudeLabelText
        avgSpeedLabel.text = viewModel.avgSpeedLabelText
        maxSpeedLabel.text = viewModel.maxSpeedLabelText
        
        configStatsLabel(withUILabel: timeLabel)
        configStatsLabel(withUILabel: distanceLabel)
        configStatsLabel(withUILabel: minAltitudeLabel)
        configStatsLabel(withUILabel: maxAltitudeLabel)
        configStatsLabel(withUILabel: avgSpeedLabel)
        configStatsLabel(withUILabel: maxSpeedLabel)
        
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(maxAltitudeLabel)
        view.addSubview(maxAltitudeLabel)
        view.addSubview(avgSpeedLabel)
        view.addSubview(maxSpeedLabel)
        
        timeLabel.frame = CGRect(x: 10, y: navigationController?.navigationBar.layer.frame.maxY ?? 30 + 20 + self.view.frame.height/4 + 10, width: self.view.frame.width - 20, height: self.view.frame.height/10)
        distanceLabel.anchor(top: timeLabel.topAnchor, left: self.view.leftAnchor, paddingTop: 10, paddingLeft: 10, width: self.view.frame.width - 20, height: self.view.frame.height/10)
        minAltitudeLabel.anchor(top: timeLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10, width: view.frame.width/2-30, height: view.frame.height/20)
        maxAltitudeLabel.anchor(top: timeLabel.bottomAnchor, left: minAltitudeLabel.rightAnchor, paddingTop: 10, paddingLeft: 10, width: view.frame.width/2-30, height: view.frame.height/20)
        avgSpeedLabel.anchor(top: minAltitudeLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10, width: view.frame.width/2-30, height: view.frame.height/20)
        maxSpeedLabel.anchor(top: maxAltitudeLabel.bottomAnchor, left: avgSpeedLabel.rightAnchor, paddingTop: 10, paddingLeft: 10, width: view.frame.width/2-30, height: view.frame.height/20)
    }
    
    
        
    func configureMapView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        
        let frame = CGRect(x: 10, y: navigationController?.navigationBar.layer.frame.maxY ?? 30 + 20, width: self.view.frame.width - 20, height: self.view.frame.height/4)
        mapView = MKMapView(frame: frame)
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 4
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.masksToBounds = true
        
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.addGestureRecognizer(tap)
        mapView.setRegion(.init(center: self.viewModel.centerLocation, latitudinalMeters: viewModel.stats.distance*2, longitudinalMeters: viewModel.stats.distance*2), animated: false)
        
        mapView.mapType = .mutedStandard
        
        mapView.addOverlays(viewModel.polylines)
        print("DEBUG: viewModel.polylines \(viewModel.polylines.count)")
        
        view.addSubview(mapView)
    }
    
    func zoomMapView(){
        mapView.layer.zPosition = 2
        UIView.animate(withDuration: 0.3) {
            let frame = CGRect(x:10, y: self.navigationController?.navigationBar.layer.frame.maxY ?? 30 + 20, width: self.view.frame.width - 20, height: self.view.frame.height/1.2)
            UIView.animate(withDuration: 0.3) {
                self.mapView.frame = frame
            }
        }
        
    }
    
    func restoreMapView(){
        mapView.setRegion(.init(center: self.viewModel.centerLocation, latitudinalMeters: viewModel.stats.distance, longitudinalMeters: viewModel.stats.distance), animated: false)
        let frame = CGRect(x:10, y: navigationController?.navigationBar.layer.frame.maxY ?? 30 + 20, width: self.view.frame.width - 20, height: self.view.frame.height/4)
        UIView.animate(withDuration: 0.3) {
            self.mapView.frame = frame
        }
        
    }
    
}

extension RunSummaryController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.mainAppColor
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
}
