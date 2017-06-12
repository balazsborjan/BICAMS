//
//  ChartContainer.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 30..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class ChartContainer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGradientLayer()
        setBounds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addGradientLayer()
        setBounds()
    }
    
    private func setBounds() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 7.0
    }
    
    private func addGradientLayer() {

        //GradientLayerGenerator.SetDefaultGradientColorTo(view: self)
        
//        let layer = CAGradientLayer()
//        
//        layer.colors = [UIColor.chartViewColor0().cgColor, UIColor.chartViewColor1().cgColor, UIColor.chartViewColor2().cgColor]
//        layer.locations = [0.3, 0.5, 0.9]
//        layer.frame = self.bounds
//        
//        if self.layer.sublayers != nil {
//            
//            self.layer.sublayers![0] = layer
//            
//        } else {
//            
//            self.layer.insertSublayer(layer, at: 0)
//        }
    }
}
