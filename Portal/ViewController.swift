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
        
        gpsLabel.text = "Lokacija"
        lookLabel.text = "Orijentacija"
        latLabel.text = "LAT:"
        lngLabel.text = "LNG:"
        latGoalLabel.text = "43.8787"
        lngGoalLabel.text = "18.3857"
        
        [gpsCircle, lookCircle].forEach({ view in
            view.backgroundColor = UIColor.red
            view.layer.cornerRadius = 15
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.black.cgColor
        })
        
        [gpsLabel, lookLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 20.0)
        })
        
        [latGoalLabel, lngGoalLabel].forEach({ view in
            view.textColor = UIColor.green
        })
        
        [latLabel, lngLabel, latValueLabel,
         lngValueLabel, latGoalLabel, lngGoalLabel].forEach({ view in
            view.font = UIFont.boldSystemFont(ofSize: 12)
         })
        
        [gpsCircle, gpsLabel, lookCircle, lookLabel, latLabel, lngLabel,
         latValueLabel, lngValueLabel, latGoalLabel, lngGoalLabel].forEach({ view in
            infoView.addSubview(view)
        })
        
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
