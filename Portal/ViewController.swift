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
    var lookCircle = UIView()
    var gpsLabel = UILabel()
    var lookLabel = UILabel()
    
    var latLabel = UILabel()
    var lngLabel = UILabel()
    var latValueLabel = UILabel()
    var lngValueLabel = UILabel()
    var latGoalLabel = UILabel()
    var lngGoalLabel = UILabel()
    
    var headingLabel = UILabel()
    var headingValueLabel = UILabel()
    var headingGoalLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // SETUP
        //
        
        cameraManager.addPreviewLayerToView(view)
        setup()
        
        //
        // LOCATION
        //
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        //
        // HEADING
        //
        
        if (CLLocationManager.headingAvailable()) {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
        
        //
        // MOTION
        //
        
//        motionManager.startAccelerometerUpdates()
//        motionManager.startGyroUpdates()
        
//        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            print("ACCELO");
            print(accelerometerData)
        }
        if let gyroData = motionManager.gyroData {
            print("GYRO");
            print(gyroData)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let roundedHeadingString = String(format: "%.0f", heading.magneticHeading)
        headingValueLabel.text = roundedHeadingString
        let roundedHeading = Int(roundedHeadingString)!
        
        if (roundedHeading > 244 && roundedHeading < 251) {
            self.lookCircle.backgroundColor = UIColor.green
        } else {
            self.lookCircle.backgroundColor = UIColor.red
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print(location.coordinate)
            
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            
            let roundedLat = String(format: "%.4f", lat)
            let roundedLng = String(format: "%.4f", lng)
            
            self.latValueLabel.text = roundedLat
            self.lngValueLabel.text = roundedLng
            
            if (roundedLat == "43.8787" && roundedLng == "18.3857") {
                self.gpsCircle.backgroundColor = UIColor.green
            } else {
                self.gpsCircle.backgroundColor = UIColor.red
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    func setup() {
        infoView.backgroundColor = UIColor.white
        infoView.layer.zPosition = 1
        
        gpsLabel.text = "Lokacija"
        lookLabel.text = "Orijentacija"
        latLabel.text = "Lat:"
        lngLabel.text = "Lng:"
        latGoalLabel.text = "43.8787"
        lngGoalLabel.text = "18.3857"
        headingLabel.text = "Smjer:"
        headingGoalLabel.text = "245-250"
        
        [gpsCircle, lookCircle].forEach({ view in
            view.backgroundColor = UIColor.red
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.black.cgColor
        })
        
        [gpsLabel, lookLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 16)
        })
        
        [latGoalLabel, lngGoalLabel, headingGoalLabel].forEach({ view in
            view.textColor = UIColor.green
        })
        
        [latLabel, lngLabel, latValueLabel,
         lngValueLabel, latGoalLabel, lngGoalLabel,
         headingLabel, headingValueLabel, headingGoalLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 12)
         })
        
        [gpsCircle, gpsLabel, lookCircle, lookLabel, latLabel, lngLabel,
         latValueLabel, lngValueLabel, latGoalLabel, lngGoalLabel, headingLabel,
         headingValueLabel, headingGoalLabel].forEach({ view in
            infoView.addSubview(view)
        })
        
        [infoView].forEach(view.addSubview)
    }
    
    func layout() {
        infoView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 105)
        
        gpsCircle.anchorInCorner(.topLeft, xPad: 10, yPad: 30, width: 16, height: 16)
        gpsLabel.align(.toTheRightCentered, relativeTo: gpsCircle, padding: 10, width: 100, height: 16)
        
        latLabel.align(.underMatchingLeft, relativeTo: gpsCircle, padding: 4, width: 40, height: 15)
        lngLabel.align(.underMatchingLeft, relativeTo: latLabel, padding: 0, width: 40, height: 15)
        
        latValueLabel.align(.toTheRightCentered, relativeTo: latLabel, padding: 4, width: 55, height: 15)
        lngValueLabel.align(.toTheRightCentered, relativeTo: lngLabel, padding: 4, width: 55, height: 15)
        
        latGoalLabel.align(.toTheRightCentered, relativeTo: latValueLabel, padding: 10, width: 55, height: 15)
        lngGoalLabel.align(.toTheRightCentered, relativeTo: lngValueLabel, padding: 10, width: 55, height: 15)
        
        lookCircle.align(.toTheRightCentered, relativeTo: gpsLabel, padding: 70, width: 15, height: 15)
        lookLabel.align(.toTheRightCentered, relativeTo: lookCircle, padding: 10, width: 105, height: 16)
        
        headingLabel.align(.underMatchingLeft, relativeTo: lookCircle, padding: 4, width: 45, height: 15)
        headingValueLabel.align(.toTheRightCentered, relativeTo: headingLabel, padding: 4, width: 35, height: 15)
        headingGoalLabel.align(.toTheRightCentered, relativeTo: headingValueLabel, padding: 10, width: 100, height: 15)
        
    }
}
