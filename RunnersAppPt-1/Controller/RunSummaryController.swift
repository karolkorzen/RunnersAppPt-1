//
//  RunSummaryController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 04/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Charts

class RunSummaryController: UIViewController {
    
    //MARK: - Properties
    
    private var mapView = MKMapView()
    var mapViewZoomed: Bool = false
    var statsViewZoomed: Bool = false
    
        //MARK: - Run Data
    private var runTable: [Location]
    private var speedChartTable:[ChartDataEntry]
    
    private var distance: CLLocationDistance
    private let locationManager = CLLocationManager()
        //
    
        //MARK: - Constraints
    var safeViewHeight: CGFloat?
    var safeTopBarHeight: CGFloat?
    var tabBarHeight: CGFloat
        //
    
    private var speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // FIXME: - make it dynamic // some library?
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // FIXME: - make it dynamic // some library?
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.setLabelCount(6, force: false)
        chartView.leftAxis.labelTextColor = .darkGray
        chartView.leftAxis.axisLineColor = .darkGray
        chartView.legend.enabled = true
        
        return chartView
    }()
    
    //MARK: - Lifecycle
    init(tabBarHeight: CGFloat, runTable: [Location], speedChartTable:[ChartDataEntry] , distance: CLLocationDistance) {
        self.tabBarHeight = tabBarHeight
        self.runTable = runTable
        self.speedChartTable = speedChartTable
        self.distance = distance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.safeViewHeight = UIApplication.shared.windows.first!.safeAreaLayoutGuide.layoutFrame.size.height
        self.safeTopBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
        addMapView()
        checkLocationServices()
        configureUI()
        addChartView()
        setChartData()
        //addChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    @objc func showController(){
        if mapViewZoomed {
            UIView.animate(withDuration: 0.3) {
                self.mapView.frame = CGRect(x: self.view.frame.width/2 + 5, y: 10, width: self.view.frame.width/2 - 15 , height: self.view.frame.height/3)
                self.mapView.isZoomEnabled = false
                self.mapView.isRotateEnabled = false
                self.mapView.isPitchEnabled = false
                self.mapView.isScrollEnabled = false
                
                let center = CLLocationCoordinate2D(latitude: self.runTable[self.runTable.count/2].latitude, longitude: self.runTable[self.runTable.count/2].longitude)
                let region = MKCoordinateRegion(center: center, latitudinalMeters: self.distance+100, longitudinalMeters: self.distance+100)
                self.mapView.setRegion(region, animated: true)
            }
        } else {
            UIView.animate(withDuration: 0.3) { [self] in
                self.mapView.frame = CGRect(x: 10, y: 10, width: self.view.frame.width-20, height: self.safeViewHeight! - self.tabBarHeight - 20)
                self.view.bringSubviewToFront(self.mapView)
                
                self.mapView.isZoomEnabled = true
                self.mapView.isRotateEnabled = true
                self.mapView.isPitchEnabled = true
                self.mapView.isScrollEnabled = true
                
                let center = CLLocationCoordinate2D(latitude: self.runTable[self.runTable.count/2].latitude, longitude: self.runTable[self.runTable.count/2].longitude)
                let region = MKCoordinateRegion(center: center, latitudinalMeters: self.distance+100, longitudinalMeters: self.distance+100)
                mapView.setRegion(region, animated: true)
            }
        }
        mapViewZoomed.toggle()
    }
    
    //MARK: - Helpers
    
    func addMapView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(showController))
        
        let frame = CGRect(x: self.view.frame.width/2 + 5, y: 10, width: self.view.frame.width/2 - 15, height: self.view.frame.height/3)
        mapView = MKMapView(frame: frame)
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 4
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.masksToBounds = true
        
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.addGestureRecognizer(tap)
    }
    
    func addChartView(){
        view.addSubview(lineChartView)
        lineChartView.anchor(left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: self.view.frame.height/2)
        lineChartView.layer.cornerRadius = 10
        lineChartView.layer.borderWidth = 4
        lineChartView.layer.borderColor = UIColor.darkGray.cgColor
        lineChartView.layer.masksToBounds = true
        self.view.bringSubviewToFront(mapView)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(speedLabel)
        speedLabel.anchor(top: mapView.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 10)
        let avgSpeed = runTable.reduce(0) { (result, location) in
            (result + location.speed) / 2
        }
        speedLabel.text = "average speed: \((avgSpeed*3.6).rounded()) km/h"
        speedLabel.textAlignment = .center
        speedLabel.setDimensions(width: self.view.frame.width/2 - 15, height: self.mapView.frame.height/2-5)
        
        view.addSubview(distanceLabel)
        distanceLabel.anchor(top: speedLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        distanceLabel.setDimensions(width: self.view.frame.width/2 - 15, height: self.mapView.frame.height/2-5)
        
        if distance.rounded()/1000 < 1 {
            self.distanceLabel.text = "\(self.distance.rounded()) m"
        } else {
            self.distanceLabel.text = "\(self.distance.rounded()/1000) km"
        }
        distanceLabel.textAlignment = .center
        
        let start = MKPointAnnotation()
        start.title = "Start"
        guard let coord_start = runTable.first?.retCLLocationCoordinate2D() else {return}
        start.coordinate = CLLocationCoordinate2D(latitude: coord_start.latitude, longitude: coord_start.longitude)
        mapView.addAnnotation(start)
        
        let stop = MKPointAnnotation()
        stop.title = "Stop"
        guard let coord_stop = runTable.first?.retCLLocationCoordinate2D() else {return}
        stop.coordinate = CLLocationCoordinate2D(latitude: coord_stop.latitude, longitude: coord_stop.longitude)
        mapView.addAnnotation(stop)
        
        
        let center = CLLocationCoordinate2D(latitude: runTable[runTable.count/2].latitude, longitude: runTable[runTable.count/2].longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: self.distance+100, longitudinalMeters: self.distance+100)
        mapView.setRegion(region, animated: true)
        
        let polylineTable = runTable.map{$0.retCLLocationCoordinate2D()}
        let polyline = MKPolyline(coordinates: polylineTable, count: polylineTable.count)
        print("DEBUG: runTable.count -> \(runTable.count)")
        print("DEBUG: polylineTable.count -> \(polylineTable.count)")
        self.mapView.addOverlay(polyline)
    }
    
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            configureLocationManager()
            checkLocationAuthorization()
        } else {
            //FIXME: - ALERT -> ENABLE LOCATION SERVICES
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //FIXME: - ALERT: TO PROPERLY USE APP SET ALWAYS IN SETTINGS
            locationManager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // not permitted by parent
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    
    func appendDistance(coord: CLLocation){
        if let last = runTable.last {
            distance += coord.distance(from: last.retCLLocation())
            //print("DEBUG: added \(coord.distance(from: last.coordinate)) to distance")
        }
    }
    
    func setChartData(){
        let set1 = LineChartDataSet(entries: speedChartTable, label: "Speed")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.pinkish)
        set1.fill = Fill(color: .pinkish)
        set1.fillAlpha = 0.6
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .black
        
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
}

extension RunSummaryController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.pinkish
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
}

extension RunSummaryController: CLLocationManagerDelegate {
}

extension RunSummaryController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("DEBUG: entry : \(entry)")
    }
}
