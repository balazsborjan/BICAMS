//
//  Chart.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 30..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class Chart: UIView {

    var resultSet: [Result] = [] { didSet { setNeedsDisplay() } }
    
    private var chartPath = UIBezierPath()
    
    var startXPos: Double = 0.0
    var xScale: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        
        startXPos = Double(self.frame.width / 10)
        xScale = startXPos * 2
    }
    
    
    private func resetChartPath() {
    
        chartPath = UIBezierPath()
        
        let heightRange = self.frame.height / 80
        
        for i in 0..<resultSet.count {
            
            let result = resultSet[i]
            
            let currentYPos = (self.superview?.frame.maxY)! - (heightRange * CGFloat(result.point)) - 5
            let currentXPos = startXPos + xScale * Double(i)
            
            drawLineChart(currentXPos: CGFloat(currentXPos), currentYPos: currentYPos, currentIndex: i)
        }
    }
    
    private func drawLineChart(currentXPos: CGFloat, currentYPos: CGFloat, currentIndex i : Int) {
        
        if i == 0 {
            
            if resultSet.count == 1 {
                
                chartPath.addArc(withCenter: CGPoint(x: currentXPos, y: currentYPos), radius: CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat.pi * 2, clockwise: true)
                
            } else {
                
                chartPath.move(to: CGPoint(x: currentXPos, y: currentYPos))
            }
            
        } else {
            
            chartPath.addLine(to: CGPoint(x: currentXPos, y: currentYPos))
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        resetChartPath()
        
        UIColor.white.setStroke()
        UIColor.white.setFill()
        
        chartPath.lineWidth = 5.0
        chartPath.lineJoinStyle = .round
        chartPath.lineCapStyle = .round
        
        chartPath.stroke()
    }

}
