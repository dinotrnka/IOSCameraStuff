//
//  ViewController.swift
//  Portal
//
//  Created by Dino Trnka on 09/02/2019.
//  Copyright © 2019 Dino Trnka. All rights reserved.
//

import UIKit
import Neon

class ViewController: UIViewController {
    let cameraManager = CameraManager()
    
    var infoView = UIView()
    var gpsCircle = UIView()
    var lookCircle = UIView()
    var gpsLabel = UILabel()
    var lookLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraManager.addPreviewLayerToView(view)
        setup()
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
        
        [gpsCircle, gpsLabel, lookCircle, lookLabel].forEach(infoView.addSubview)
        [infoView].forEach(view.addSubview)
    }
    
    func layout() {
        infoView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 70)
        
        gpsCircle.anchorInCorner(.topLeft, xPad: 10, yPad: 30, width: 30, height: 30)
        gpsLabel.align(.toTheRightCentered, relativeTo: gpsCircle, padding: 10, width: 100, height: 50)
        
        lookCircle.anchorInCorner(.topRight, xPad: 10, yPad: 30, width: 30, height: 30)
        lookLabel.align(.toTheLeftCentered, relativeTo: lookCircle, padding: 10, width: 105, height: 50)
    }
}
