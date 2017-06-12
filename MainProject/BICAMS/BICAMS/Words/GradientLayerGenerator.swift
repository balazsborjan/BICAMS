//
//  GradientColor.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 17..
//  Copyright © 2017. SZTE. All rights reserved.
//

import Foundation
import UIKit

struct GradientLayerGenerator {
    
    static func GetGradientLayerWith(color1: UIColor, color2: UIColor, frame: CGRect) -> CAGradientLayer {
        
        let layer = CAGradientLayer()
        
        layer.colors = [color1.cgColor, color2.cgColor]
        layer.locations = [0.0, 0.8]
        layer.frame = frame
        
        return layer
    }
    
    static func SetDefaultGradientColorTo(view: UIView) {
        
        let layer = CAGradientLayer()
        
        layer.colors = [UIColor.chartViewColor0().cgColor, UIColor.chartViewColor1().cgColor, UIColor.chartViewColor2().cgColor]
        layer.locations = [0.3, 0.5, 0.9]
        layer.frame = view.bounds
        
        if view.layer.sublayers != nil {
            
            view.layer.sublayers![0] = layer
            
        } else {
            
            view.layer.insertSublayer(layer, at: 0)
        }
    }
}
