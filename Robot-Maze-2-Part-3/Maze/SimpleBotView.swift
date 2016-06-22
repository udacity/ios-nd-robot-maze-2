//
//  SimpleRobotView.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - SimpleRobotView

class SimpleRobotView: UIView {
    
    // MARK: Properties
    
    var color: UIColor = UIColor.white()
    var lineWidth: CGFloat = 5
    var border: CGFloat = 15
    
    // MARK: UIView
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
 
        let robotRect = self.bounds.insetBy(dx: border, dy: border)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.clear(rect)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(color.cgColor)
        context?.strokeEllipse(in: robotRect)
        
        context?.setLineWidth(3)
        context?.strokeEllipse(in: CGRect(x: 22, y: 19, width: 2, height: 2))
        context?.strokeEllipse(in: CGRect(x: 27, y: 19, width: 2, height: 2))
        
        context?.restoreGState()
    }
    
}
