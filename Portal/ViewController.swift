//
//  ViewController.swift
//  Portal
//
//  Created by Dino Trnka on 09/02/2019.
//  Copyright © 2019 Dino Trnka. All rights reserved.
//

import UIKit
import Neon
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let cameraManager = CameraManager()
    var motionManager = CMMotionManager()
    var timer: Timer!
    var infoView = UIView()
    var gpsCircle = UIView()
    var gpsLabel = UILabel()
    var latLabel = UILabel()
    var lngLabel = UILabel()
    var latValueLabel = UILabel()
    var lngValueLabel = UILabel()
    var latGoalLabel = UILabel()
    var lngGoalLabel = UILabel()
    var compassCircle = UIView()
    var compassLabel = UILabel()
    var headingLabel = UILabel()
    var headingValueLabel = UILabel()
    var headingGoalLabel = UILabel()
    var yAxisCircle = UIView()
    var yAxisLabel = UILabel()
    var yLabel = UILabel()
    var yValueLabel = UILabel()
    var yGoalLabel = UILabel()
    var mainIndicator = UIView()
    
    let latFrom = 43.8786
    let latTo = 43.8787
    let lngFrom = 18.3856
    let lngTo = 18.3857
    let headingFrom = 245
    let headingTo = 250
    let yFrom = 0.1
    let yTo = -0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraManager.addPreviewLayerToView(view)
        setup()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        if (CLLocationManager.headingAvailable()) {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
        
        motionManager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func updateMainIndicator() {
        if (self.gpsCircle.backgroundColor === UIColor.green
            && self.compassCircle.backgroundColor === UIColor.green
            && self.yAxisCircle.backgroundColor === UIColor.green) {
            self.mainIndicator.backgroundColor = UIColor.green
        } else {
            self.mainIndicator.backgroundColor = UIColor.red
        }
    }
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            let roundedYAxisString = String(format: "%.1f", accelerometerData.acceleration.z)
            let roundedYAxis = Double(roundedYAxisString)!
            self.yValueLabel.text = roundedYAxisString
            
            if (roundedYAxis <= yFrom && roundedYAxis >= yTo) {
                self.yAxisCircle.backgroundColor = UIColor.green
            } else {
                self.yAxisCircle.backgroundColor = UIColor.red
            }
            
            self.updateMainIndicator()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let roundedHeadingString = String(format: "%.0f", heading.magneticHeading)
        headingValueLabel.text = roundedHeadingString
        let roundedHeading = Int(roundedHeadingString)!
        
        if (roundedHeading >= headingFrom && roundedHeading <= headingTo) {
            self.compassCircle.backgroundColor = UIColor.green
        } else {
            self.compassCircle.backgroundColor = UIColor.red
        }
        
        self.updateMainIndicator()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            
            let roundedLatString = String(format: "%.4f", lat)
            let roundedLngString = String(format: "%.4f", lng)
            let roundedLat = Double(roundedLatString)!
            let roundedLng = Double(roundedLngString)!
            
            self.latValueLabel.text = roundedLatString
            self.lngValueLabel.text = roundedLngString
            
            if (roundedLat >= latFrom && roundedLat <= latTo
                && roundedLng >= lngFrom && roundedLng <= lngTo) {
                self.gpsCircle.backgroundColor = UIColor.green
            } else {
                self.gpsCircle.backgroundColor = UIColor.red
            }
            
            self.updateMainIndicator()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    func setup() {
        infoView.backgroundColor = UIColor.white
        
        mainIndicator.backgroundColor = UIColor.red
        mainIndicator.layer.borderWidth = 2
        mainIndicator.layer.borderColor = UIColor.black.cgColor
        
        gpsLabel.text = "GPS Lokacija"
        compassLabel.text = "Kompas"
        yAxisLabel.text = "Nagib"
        latLabel.text = "Latituda:"
        lngLabel.text = "Longituda:"
        latGoalLabel.text = "\(latFrom) do \(latTo)"
        lngGoalLabel.text = "\(lngFrom) do \(lngTo)"
        headingLabel.text = "Smjer:"
        headingGoalLabel.text = "\(headingFrom) do \(headingTo)"
        yLabel.text = "Y osa:"
        yGoalLabel.text = "\(yFrom) do \(yTo)"
        
        [infoView, mainIndicator].forEach({ view in
            view.layer.zPosition = 1
        })
        
        [gpsCircle, compassCircle,
         yAxisCircle].forEach({ view in
            view.backgroundColor = UIColor.red
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.black.cgColor
        })
        
        [gpsLabel, compassLabel, yAxisLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 16)
        })
        
        [latGoalLabel, lngGoalLabel,
         headingGoalLabel, yGoalLabel].forEach({ view in
            view.textColor = UIColor.green
        })
        
        [latLabel, lngLabel, latValueLabel,
         lngValueLabel, latGoalLabel, lngGoalLabel,
         headingLabel, headingValueLabel, headingGoalLabel,
         yLabel, yValueLabel, yGoalLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 12)
         })
        
        [gpsCircle, gpsLabel, compassCircle, compassLabel, latLabel, lngLabel,
         latValueLabel, lngValueLabel, latGoalLabel, lngGoalLabel, headingLabel,
         headingValueLabel, headingGoalLabel, yAxisCircle, yAxisLabel,
         yLabel, yValueLabel, yGoalLabel].forEach({ view in
            infoView.addSubview(view)
        })
        
        [infoView, mainIndicator].forEach(view.addSubview)
    }
    
    func layout() {
        infoView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 120)
        mainIndicator.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 50)
        gpsCircle.anchorInCorner(.topLeft, xPad: 10, yPad: 30, width: 16, height: 16)
        gpsLabel.align(.toTheRightCentered, relativeTo: gpsCircle, padding: 10, width: 110, height: 18)
        latLabel.align(.underMatchingLeft, relativeTo: gpsCircle, padding: 6, width: 65, height: 15)
        latValueLabel.align(.toTheRightCentered, relativeTo: latLabel, padding: 4, width: 55, height: 15)
        latGoalLabel.align(.underMatchingLeft, relativeTo: latLabel, padding: 0, width: 150, height: 15)
        lngLabel.align(.underMatchingLeft, relativeTo: latGoalLabel, padding: 4, width: 65, height: 15)
        lngValueLabel.align(.toTheRightCentered, relativeTo: lngLabel, padding: 4, width: 55, height: 15)
        lngGoalLabel.align(.underMatchingLeft, relativeTo: lngLabel, padding: 0, width: 150, height: 15)
        compassCircle.align(.toTheRightCentered, relativeTo: gpsLabel, padding: 20, width: 15, height: 15)
        compassLabel.align(.toTheRightCentered, relativeTo: compassCircle, padding: 10, width: 80, height: 18)
        headingLabel.align(.underMatchingLeft, relativeTo: compassCircle, padding: 6, width: 45, height: 15)
        headingValueLabel.align(.toTheRightCentered, relativeTo: headingLabel, padding: 4, width: 35, height: 15)
        headingGoalLabel.align(.underMatchingLeft, relativeTo: headingLabel, padding: 0, width: 100, height: 15)
        yAxisCircle.align(.toTheRightCentered, relativeTo: compassLabel, padding: 10, width: 16, height: 16)
        yAxisLabel.align(.toTheRightCentered, relativeTo: yAxisCircle, padding: 10, width: 105, height: 18)
        yLabel.align(.underMatchingLeft, relativeTo: yAxisCircle, padding: 6, width: 45, height: 16)
        yValueLabel.align(.toTheRightCentered, relativeTo: yLabel, padding: 4, width: 35, height: 15)
        yGoalLabel.align(.underMatchingLeft, relativeTo: yLabel, padding: 0, width: 100, height: 15)
    }
}
