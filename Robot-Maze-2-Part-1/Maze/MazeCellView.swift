//
//  MazeCell.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - MazeCellView

class MazeCellView : UIView {
    
    // MARK: Properties
    
    var wallColor: UIColor = UIColor.orangeColor()
    var cellModel: MazeCellModel?
    var wallWidth: CGFloat = 1

    // MARK: UIView
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let cellModel = cellModel {
     
            // Set the wallColor
            wallColor.set()
            
            let width = bounds.width
            let height = bounds.height
            let path = CGPathCreateMutable()
            
            // Half wallWidth
            let hw = wallWidth / CGFloat(2)
            
            if cellModel.top {
                CGPathMoveToPoint(path, nil, 0 - hw, 0)
                CGPathAddLineToPoint(path, nil, width + hw, 0)
            }
            
            if cellModel.right {
                CGPathMoveToPoint(path, nil, width, 0)
                CGPathAddLineToPoint(path, nil, width, height)
            }
            
            if cellModel.bottom {
                CGPathMoveToPoint(path, nil, width + hw, height)
                CGPathAddLineToPoint(path, nil, 0 - hw, height)
            }
            
            if cellModel.left {
                CGPathMoveToPoint(path, nil, 0, height)
                CGPathAddLineToPoint(path, nil, 0, 0)
            }
            
            let bezierPath = UIBezierPath(CGPath: path)
            
            bezierPath.lineWidth = wallWidth;
            bezierPath.stroke()
            
            // Rounded corners
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            let nearCornerValue = -0.5 * wallWidth
            let farCornerValue = width + nearCornerValue
            CGContextFillEllipseInRect(context, CGRect(x: nearCornerValue, y: nearCornerValue, width: wallWidth, height: wallWidth))
            CGContextFillEllipseInRect(context, CGRect(x: farCornerValue, y: farCornerValue, width: wallWidth, height: wallWidth))
            CGContextFillEllipseInRect(context, CGRect(x: farCornerValue, y: nearCornerValue, width: wallWidth, height: wallWidth))
            CGContextFillEllipseInRect(context, CGRect(x: nearCornerValue, y: farCornerValue, width: wallWidth, height: wallWidth))
            CGContextRestoreGState(context)
        }
    }
}
