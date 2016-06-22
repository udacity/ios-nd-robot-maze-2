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
    
    var color: UIColor = UIColor.whiteColor()
    var lineWidth: CGFloat = 5
    var border: CGFloat = 15
    
    // MARK: UIView
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
 
        let robotRect = CGRectInset(self.bounds, border, border)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextClearRect(context, rect)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextStrokeEllipseInRect(context, robotRect)
        
        CGContextSetLineWidth(context, 3)
        CGContextStrokeEllipseInRect(context, CGRectMake(22, 19, 2, 2))
        CGContextStrokeEllipseInRect(context, CGRectMake(27, 19, 2, 2))
        
        CGContextRestoreGState(context)
    }
    
}