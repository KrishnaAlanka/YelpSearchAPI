//
//  CircularRating.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation
import UIKit

class CircularRating: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    var value: Float = 0.0
    
    var progressColor = UIColor(red: 18.0/255.0,
                                green: 119.0/255.0,
                                blue: 174.0/255.0,
                                alpha: 1.0) {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    //     Only override draw() if you perform custom drawing.
    //     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath.init(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: -0.5 * .pi, endAngle:1.5 * .pi , clockwise: true)
        trackLayer.path =  circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 3.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path =  circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 3.0
        progressLayer.strokeEnd = CGFloat(0.2 * value)
        layer.addSublayer(progressLayer)
    }
    
}
