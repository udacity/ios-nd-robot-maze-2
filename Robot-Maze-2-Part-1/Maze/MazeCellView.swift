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
    
    var wallColor: UIColor = UIColor.orange
    var cellModel: MazeCellModel?
    var wallWidth: CGFloat = 1

    // MARK: UIView
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let cellModel = cellModel {
     
            // Set the wallColor
            wallColor.set()
            
            let width = bounds.width
            let height = bounds.height
            let path = CGMutablePath()
            
            // Half wallWidth
            let hw = wallWidth / CGFloat(2)
            
            if cellModel.top {
                path.move(to: CGPoint(x: 0 - hw, y: 0))
                path.addLine(to: CGPoint(x: width + hw, y: 0))
            }
            
            if cellModel.right {
                path.move(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: height))
            }
            
            if cellModel.bottom {
                path.move(to: CGPoint(x: width + hw, y: height))
                path.addLine(to: CGPoint(x: 0 - hw, y: height))
            }
            
            if cellModel.left {
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: 0))                
            }
            
            let bezierPath = UIBezierPath(cgPath: path)
            
            bezierPath.lineWidth = wallWidth;
            bezierPath.stroke()
            
            // Rounded corners
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            let nearCornerValue = -0.5 * wallWidth
            let farCornerValue = width + nearCornerValue
            context?.fillEllipse(in: CGRect(x: nearCornerValue, y: nearCornerValue, width: wallWidth, height: wallWidth))
            context?.fillEllipse(in: CGRect(x: farCornerValue, y: farCornerValue, width: wallWidth, height: wallWidth))
            context?.fillEllipse(in: CGRect(x: farCornerValue, y: nearCornerValue, width: wallWidth, height: wallWidth))
            context?.fillEllipse(in: CGRect(x: nearCornerValue, y: farCornerValue, width: wallWidth, height: wallWidth))
            context?.restoreGState()
        }
    }
}
