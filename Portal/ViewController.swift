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

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let cameraManager = CameraManager()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        cameraManager.addPreviewLayerToView(view)
        
        setup()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            
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
        
        gpsCircle = UIView()
        gpsCircle.backgroundColor = UIColor.red
        gpsCircle.layer.cornerRadius = 15
        gpsCircle.layer.borderWidth = 2
        gpsCircle.layer.borderColor = UIColor.black.cgColor
        gpsCircle.layer.zPosition = 1
        
        gpsLabel.text = "Lokacija"
        gpsLabel.textColor = UIColor.black
        gpsLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        gpsLabel.layer.zPosition = 1
        
        lookCircle = UIView()
        lookCircle.backgroundColor = UIColor.red
        lookCircle.layer.cornerRadius = 15
        lookCircle.layer.borderWidth = 2
        lookCircle.layer.borderColor = UIColor.black.cgColor
        lookCircle.layer.zPosition = 1
        
        lookLabel.text = "Orijentacija"
        lookLabel.textColor = UIColor.black
        lookLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        lookLabel.layer.zPosition = 1
        
        latLabel.textColor = UIColor.black
        latLabel.font = UIFont.boldSystemFont(ofSize: 12)
        latLabel.layer.zPosition = 1
        latLabel.text = "LAT:"
        
        lngLabel.textColor = UIColor.black
        lngLabel.font = UIFont.boldSystemFont(ofSize: 12)
        lngLabel.layer.zPosition = 1
        lngLabel.text = "LNG:"
        
        latValueLabel.textColor = UIColor.black
        latValueLabel.font = UIFont.boldSystemFont(ofSize: 12)
        latValueLabel.layer.zPosition = 1
        
        lngValueLabel.textColor = UIColor.black
        lngValueLabel.font = UIFont.boldSystemFont(ofSize: 12)
        lngValueLabel.layer.zPosition = 1
        
        latGoalLabel.textColor = UIColor.green
        latGoalLabel.font = UIFont.boldSystemFont(ofSize: 12)
        latGoalLabel.layer.zPosition = 1
        latGoalLabel.text = "43.8787"
        
        lngGoalLabel.textColor = UIColor.green
        lngGoalLabel.font = UIFont.boldSystemFont(ofSize: 12)
        lngGoalLabel.layer.zPosition = 1
        lngGoalLabel.text = "18.3857"
        
        [gpsCircle, gpsLabel, lookCircle, lookLabel, latLabel, lngLabel,
         latValueLabel, lngValueLabel, latGoalLabel, lngGoalLabel].forEach(infoView.addSubview)
        
        [infoView].forEach(view.addSubview)
    }
    
    func layout() {
        infoView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 105)
        
        gpsCircle.anchorInCorner(.topLeft, xPad: 10, yPad: 30, width: 30, height: 30)
        gpsLabel.align(.toTheRightCentered, relativeTo: gpsCircle, padding: 10, width: 100, height: 50)
        
        latLabel.align(.underMatchingLeft, relativeTo: gpsCircle, padding: 4, width: 40, height: 15)
        lngLabel.align(.underMatchingLeft, relativeTo: latLabel, padding: 0, width: 40, height: 15)
        
        latValueLabel.align(.toTheRightCentered, relativeTo: latLabel, padding: 4, width: 55, height: 15)
        lngValueLabel.align(.toTheRightCentered, relativeTo: lngLabel, padding: 4, width: 55, height: 15)
        
        latGoalLabel.align(.toTheRightCentered, relativeTo: latValueLabel, padding: 10, width: 55, height: 15)
        lngGoalLabel.align(.toTheRightCentered, relativeTo: lngValueLabel, padding: 10, width: 55, height: 15)
        
        lookCircle.anchorInCorner(.topRight, xPad: 10, yPad: 30, width: 30, height: 30)
        lookLabel.align(.toTheLeftCentered, relativeTo: lookCircle, padding: 10, width: 105, height: 50)
    }
}
