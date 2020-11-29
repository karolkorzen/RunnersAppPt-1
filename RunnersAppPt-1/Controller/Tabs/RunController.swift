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
import FloatingPanel

//FIXME: - Whole charts are dumb

class RunController: UIViewController {
    
    //MARK: - Properties
    private let viewModel = RunViewModel()
    private var timer = Timer()
    
    private var runTable: [Location] = []
    private var isRunning: Bool = false
    private var polylineTable: [CLLocationCoordinate2D]  = []
    private var speedChartTable:[ChartDataEntry] = [] {
        didSet{
                setChartData()
        }
    }
    
    
    private var mapView = MKMapView()
    var mapViewZoomed: Bool = false
    
    private var distance: CLLocationDistance = 0
    private var time: Int = 0
    private let locationManager = CLLocationManager()
    
    var safeViewHeight: CGFloat?
    var safeTopBarHeight: CGFloat?
    var tabBarHeight: CGFloat
    
    private var speedLabel = Utilities.shared.infoRunLabel()
    private var distanceLabel = Utilities.shared.infoRunLabel()
    private var timeLabel = Utilities.shared.infoRunLabel()
    
    private var runButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .mainAppColor
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(toggleRunButton), for: .touchUpInside)
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
        chartView.isUserInteractionEnabled = false
        
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
        configureMapView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - API
    
    //MARK: - Selectors
    
    @objc func toggleRunButton() {
        if isRunning == false {
            startTraining()
        } else {
            stopTraining()
        }
    }
    
    @objc func mapViewTapped(){
        guard let location = self.locationManager.location else {return}
        if mapViewZoomed {
            restoreMapView(withLocation: location)
        } else {
            zoomMapView(withLocation: location)
        }
        mapViewZoomed.toggle()
    }
    
    //MARK: - Helpers
    
    func startTraining() {
        UIView.animate(withDuration: 0.5) {
            self.runButton.setTitle("STOP", for: .normal)
            self.runButton.backgroundColor = UIColor(red: 0.13, green: 0.19, blue: 0.25, alpha: 1.00)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAppend), userInfo: nil, repeats: true)
        }
        self.isRunning.toggle()
    }
    
    @objc func timerAppend() {
        time+=1
        timeLabel.text = "\(time) s"
    }
    
    func stopTraining(){
        if runTable.count > 1 {
            let alert = configAlert()
            self.present(alert, animated: true, completion: nil)
        } else {
            finishTraining(withSavingDecision: false)
        }
    }
    
    func restoreMapView(withLocation location: CLLocation){
        UIView.animate(withDuration: 0.3) {
            self.mapView.frame = CGRect(x: self.view.frame.width/2 + 5, y: self.safeTopBarHeight! + 10, width: self.view.frame.width/2 - 15 , height: self.view.frame.height/3)
        }
        self.mapView.isZoomEnabled = false
        self.mapView.isRotateEnabled = false
        self.mapView.isPitchEnabled = false
        self.mapView.isScrollEnabled = false
        self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
//        let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: 100, pitch: 0, heading: location.course)
//        self.mapView.setCamera(mapCamera, animated: false)
    }
    
    func zoomMapView(withLocation location: CLLocation){
        UIView.animate(withDuration: 0.3) {
            self.mapView.frame = CGRect(x: 10, y: self.safeTopBarHeight!+10, width: self.view.frame.width-20, height: self.safeViewHeight! - self.tabBarHeight - 20)
        }
        self.view.bringSubviewToFront(self.mapView)
        self.mapView.isZoomEnabled = true
        self.mapView.isRotateEnabled = true
        self.mapView.isPitchEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.setUserTrackingMode(.none, animated: true)
        let dist = self.distance > 50 ? self.distance : 400
        let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: dist, pitch: 0, heading: 0)
        self.mapView.setCamera(mapCamera, animated: true)
    }
    
    func configureMapView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        
        let frame = CGRect(x: self.view.frame.width/2 + 5, y: self.safeTopBarHeight! + 10, width: self.view.frame.width/2 - 15, height: self.view.frame.height/3)
        mapView = MKMapView(frame: frame)
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 4
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.masksToBounds = true
        
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.addGestureRecognizer(tap)
        
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        
        view.addSubview(mapView)
        
    }
    
    func configAlert() -> UIAlertController{
        let alert = UIAlertController(title: "Do you want to save your training?", message: nil, preferredStyle: .actionSheet)
    
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.finishTraining(withSavingDecision: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (UIAlertAction) in
            self.finishTraining(withSavingDecision: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    func finishTraining(withSavingDecision decision: Bool){

        if decision {
            let stats = viewModel.createStats(runTable: runTable, distance: distance, time: Double(time))
            RunService.shared.uploadRunSession(withRunSession: self.runTable, withStats: stats)
            let controller = RunSummaryController(withStats: stats, withDeleteEnabled: false)
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
        }
        self.timer.invalidate()
        self.time = 0
        self.isRunning.toggle()
        self.runTable.removeAll()
        self.distance = 0.0
        self.speedChartTable.removeAll()
        self.polylineTable.removeAll()
        
        UIView.animate(withDuration: 0.5) {
            self.distanceLabel.text = self.viewModel.distanceLabelText(withDistance: self.distance)
            self.timeLabel.text = "\(self.time) s"
            self.runButton.setTitle("START", for: .normal)
            self.runButton.backgroundColor = .mainAppColor
        }
    }
    
    func addChartView(){
        view.addSubview(lineChartView)
        lineChartView.anchor(top: runButton.bottomAnchor, left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
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
        
        view.addSubview(timeLabel)
        timeLabel.anchor(top: distanceLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        timeLabel.setDimensions(width: self.view.frame.width/2 - 15, height: self.view.frame.height/8)
        timeLabel.text = "00:00"
        timeLabel.textAlignment = .center
        
        
        
        //FIXME: - MAKE A STACK WITH TIME WHEN USER IS RUNNING
        //FIXME: - DIVIDE SCREEN TO 5 BLOCKS
        view.addSubview(runButton)
        runButton.anchor(top: distanceLabel.bottomAnchor, left: timeLabel.rightAnchor, paddingTop: 10, paddingLeft: 10)
        
        runButton.setDimensions(width: self.view.frame.width/2 - 15, height: self.view.frame.height/8)
        
        self.addChartView()
        setChartData()
    }
    
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
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
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //FIXME: - ALERT: TO PROPERLY USE APP SET ALWAYS IN SETTINGS
            locationManager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            break
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted: // not permitted by parent
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            break
        @unknown default:
            break
        }
    }
    
    func setChartData(){
        let set1 = LineChartDataSet(entries: speedChartTable, label: "Speed")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.mainAppColor)
        set1.fill = Fill(color: .mainAppColor)
        set1.fillAlpha = 0.6
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .black

        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    func handleNewLocation(withLocation location: CLLocation){
        self.speedLabel.text = viewModel.speedLabelText(withSpeed: location.speed)
        if isRunning && location.speed>0.0 {
            if let last = runTable.last {
                self.distance = viewModel.appendDistance(withCurrentDistance: self.distance, fromLocation: (last.retFullCLLocation()), toLocation: location)
                self.distanceLabel.text = viewModel.distanceLabelText(withDistance: self.distance)
            }
            self.runTable = viewModel.appendRunTable(withTable: runTable, withNewLocation: location)
            
            self.speedChartTable.append(ChartDataEntry(x: Double(self.speedChartTable.count), y: viewModel.retSpeedRounded(withSpeed: location.speed) ))
        }
    }
}

//MARK: - MKMapViewDelegate

extension RunController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
            case let user as MKUserLocation:
                if let existingView = mapView
                    .dequeueReusableAnnotationView(withIdentifier: "user") {
                    return existingView
                } else {
                    let view = MKAnnotationView(annotation: user, reuseIdentifier: "user")
                    view.image = UIImage(systemName: "location.north.fill")
                    return view
                }
                
            default:
                return nil
        }
    }
    
    
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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        guard let location = locationManager.location else {return}
//        if !mapViewZoomed {
//            let mapCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), fromDistance: 100, pitch: 60, heading: location.course)
//            self.mapView.setCamera(mapCamera, animated: true)
//        }
        if isRunning {
            let polyline = MKPolyline(coordinates: viewModel.retRunTablesCLLocationCoordinates2D(withTable: runTable), count: runTable.count)
            addPolyline(withPolyline: polyline)
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension RunController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.showsUserLocation = true

        guard let location = locations.last else {return}
        handleNewLocation(withLocation: location)
        
        //FIXME: - IN BACKGROUND MODE
//            print(polylineTable.count)
//            if UIApplication.shared.applicationState == .active {
//                print("DEBUG: inside app: \(polylineTable.count)")
//            } else {
//                print("DEBUG: outside app: \(polylineTable.count)")
//            }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("DEBUG: didChangeAuthorization")
        checkLocationAuthorization() //inits after setting allow or not to localize
    }
    
    func addPolyline(withPolyline polyline: MKPolyline) {
        self.mapView.addOverlay(polyline)
    }
    
}
