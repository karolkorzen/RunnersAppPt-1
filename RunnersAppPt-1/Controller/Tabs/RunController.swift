//
//  RunController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 29/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Charts

class RunController: UIViewController {
    
    //MARK: - Properties
    
    private var mapView = MKMapView()
    var mapViewZoomed: Bool = false
    var statsViewZoomed: Bool = false
    
    private var runTable: [Location] = []
    private var isRunning: Bool = false
    private var polylineTable: [CLLocationCoordinate2D]  = []
    private var speedChartTable:[ChartDataEntry] = [] {
        didSet{
            setChartData()
        }
    }
    
    private var distance: CLLocationDistance = 0
    private let locationManager = CLLocationManager()
    
    
    var safeViewHeight: CGFloat?
    var safeTopBarHeight: CGFloat?
    
    var tabBarHeight: CGFloat
    
    private var speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // FIXME: - make it dynamic // some library?
        label.font = UIFont.boldSystemFont(ofSize: 30)
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
    
    private var runButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .pinkish
        button.titleLabel?.text = "START"
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(toggleRunButton), for: .touchUpInside)
        return button
    }()
    
    private var stopButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.titleLabel?.text = "STOP"
        
        return button
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
    init(tabBarHeight: CGFloat) {
        self.tabBarHeight = tabBarHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.safeViewHeight = UIApplication.shared.windows.first!.safeAreaLayoutGuide.layoutFrame.size.height
        self.safeTopBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
        checkLocationServices()
        addMapView()
        addRunInfo()
        configureUI()
        
        //addChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    @objc func toggleRunButton() {
        if isRunning == false {
            UIView.animate(withDuration: 0.5) {
                self.runButton.setTitle("STOP", for: .normal)
                self.runButton.backgroundColor = .red
                self.addChartView()
                self.isRunning.toggle()
                
                self.runTable.append(Location(number: self.runTable.count, coordinate: self.locationManager.location!))
                print("DEBUG: first location's speed = \(self.locationManager.location!.speed)")
                
                self.polylineTable = self.runTable.map{CLLocationCoordinate2D(latitude: $0.coordinate.coordinate.latitude, longitude: $0.coordinate.coordinate.longitude)}
                let polyline = MKPolyline(coordinates: self.polylineTable, count: self.polylineTable.count)
                self.addPolyline(withPolyline: polyline)
                print("DEBUG: polyline count = \(polyline.pointCount)")
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                let alert = UIAlertController(title: "Do you want to save your training?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                    RunService.shared.uploadRunSession(withRunSession: self.runTable) {
                        print("DEBUG: UPDATED RUN SESSION")
                    }
                    self.runButton.setTitle("START", for: .normal)
            
                    
                    let summary = RunSummaryController(tabBarHeight: self.tabBarHeight, runTable: self.runTable, speedChartTable: self.speedChartTable, distance: self.distance)
                    self.present(summary, animated: true, completion: nil)
                    self.runButton.backgroundColor = .blue
                    self.runTable.removeAll()
                    self.distance = 0.0
                    self.speedChartTable.removeAll()
                    self.polylineTable.removeAll()
                    self.isRunning.toggle()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (UIAlertAction) in
                    self.runButton.setTitle("START", for: .normal)
                    self.runButton.backgroundColor = .blue
                    self.runTable.removeAll()
                    self.distance = 0.0
                    self.speedChartTable.removeAll()
                    self.polylineTable.removeAll()
                    self.isRunning.toggle()
                }))
                alert.addAction(UIAlertAction(title: "I want to continue training!!!", style: .cancel, handler: { (UIAlertAction) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        print("DEBUG: runTable.count -> \(runTable.count)")
    }
    
    @objc func showController(){
        if mapViewZoomed {
            UIView.animate(withDuration: 0.3) {
                self.mapView.frame = CGRect(x: self.view.frame.width/2 + 5, y: self.safeTopBarHeight! + 10, width: self.view.frame.width/2 - 15 , height: self.view.frame.height/3)
                self.mapView.isZoomEnabled = false
                self.mapView.isRotateEnabled = false
                self.mapView.isPitchEnabled = false
                self.mapView.isScrollEnabled = false
                guard let location = self.locationManager.location else {return}
                let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: 100, pitch: 60, heading: location.course)
                self.mapView.setCamera(mapCamera, animated: true)
            }
        } else {
            UIView.animate(withDuration: 0.3) { [self] in
                self.mapView.frame = CGRect(x: 10, y: self.safeTopBarHeight!+10, width: self.view.frame.width-20, height: self.safeViewHeight! - self.tabBarHeight - 20)
                self.view.bringSubviewToFront(self.mapView)
                
                self.mapView.isZoomEnabled = true
                self.mapView.isRotateEnabled = true
                self.mapView.isPitchEnabled = true
                self.mapView.isScrollEnabled = true
                guard let location = self.locationManager.location else {return}
                let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: 400, pitch: 0, heading: 0)
                self.mapView.setCamera(mapCamera, animated: true)
            }
        }
        mapViewZoomed.toggle()
    }
    
    @objc func showStatsController() {
        if statsViewZoomed {
            print(statsViewZoomed)
        } else {
            print(statsViewZoomed)
        }
        statsViewZoomed.toggle()
    }
    
    //MARK: - Helpers
    
    func addMapView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(showController))
        
        let frame = CGRect(x: self.view.frame.width/2 + 5, y: self.safeTopBarHeight! + 10, width: self.view.frame.width/2 - 15, height: self.view.frame.height/3)
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
        lineChartView.anchor(top: runButton.bottomAnchor,left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
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
        speedLabel.text = "0 k/m"
        speedLabel.textAlignment = .center
        speedLabel.setDimensions(width: self.view.frame.width/2 - 15, height: self.mapView.frame.height/2-5)
        
        view.addSubview(distanceLabel)
        distanceLabel.anchor(top: speedLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        distanceLabel.setDimensions(width: self.view.frame.width/2 - 15, height: self.mapView.frame.height/2-5)
        distanceLabel.text = "0 m"
        distanceLabel.textAlignment = .center
        
        view.addSubview(runButton)
        runButton.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        runButton.setDimensions(width: self.view.frame.width - 20, height: self.view.frame.height/8)
        
    }
    
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        
//        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            configureLocationManager()
            checkLocationAuthorization()
        } else {
            //FIXME: - ALERT -> ENABLE LOCATION SERVICES
        }
    }
    
    func centerViewOnUserLocation() { //FIXME: -not used much ONLY ONCE LOL
        if let location = locationManager.location?.coordinate{
            print("DEBUG: inside centerViewOnUserLocation with location \(location)")
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 100, longitudinalMeters: 100) //FIXME: - Dynamic for route size?
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //FIXME: - ALERT: TO PROPERLY USE APP SET ALWAYS IN SETTINGS
            locationManager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
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
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    func addRunInfo (){
        
    }
    
    
    func appendDistance(coord: CLLocation){
        if let last = runTable.last {
            distance += coord.distance(from: last.coordinate)
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

extension RunController: MKMapViewDelegate {
    
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
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        //print("DEBUG: LOCATING USER")
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //print("DEBUG: updated user location")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print("DEBUG: didSelect view!")
    }
}

extension RunController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        
        if !self.mapViewZoomed{
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
//            self.mapView.setRegion(region, animated: true)
            let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: 100, pitch: 60, heading: location.course)
            self.mapView.setCamera(mapCamera, animated: true)
            
        }
        
        self.speedLabel.text = location.speed > 0.0 ? "\((location.speed*3.6).rounded()) km/h" : "0 km/h"
        self.distanceLabel.text = "0.0 m"
        
        if isRunning && location.speed>0.6 /*&& location.horizontalAccuracy <= 10.0*/ {
            appendDistance(coord: location)
            if distance.rounded()/1000 < 1 {
                self.distanceLabel.text = "\(self.distance.rounded()) m"
            } else {
                self.distanceLabel.text = "\(self.distance.rounded()/1000) km"
            }
            
            
            self.runTable.append(Location(number: runTable.count, coordinate: location))
            self.speedChartTable.append(ChartDataEntry(x: Double(self.speedChartTable.count), y: location.speed*3.6))
            
            self.polylineTable = runTable.map{CLLocationCoordinate2D(latitude: $0.coordinate.coordinate.latitude, longitude: $0.coordinate.coordinate.longitude)}
            let polyline = MKPolyline(coordinates: polylineTable, count: polylineTable.count)
            
//            print(polylineTable.count)
            if UIApplication.shared.applicationState == .active {
                print("DEBUG: inside app: \(polylineTable.count)")
            } else {
                print("DEBUG: outside app: \(polylineTable.count)")
            }
            
            addPolyline(withPolyline: polyline)
            //self.mapView.addOverlay(polyline)
            
        }
        
        mapView.showsUserLocation = true
        //print("DEBUG: didUpdateLocations with \(location.timestamp)")
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("DEBUG: didChangeAuthorization")
        checkLocationAuthorization() //inits after setting allow or not to localize
    }
    
    func addPolyline(withPolyline polyline: MKPolyline) {
        self.mapView.addOverlay(polyline)
    }
    
}

extension RunController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("DEBUG: entry : \(entry)")
    }
}
