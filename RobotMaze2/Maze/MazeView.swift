//
//  MazeView.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - MazeViewDelegate

protocol MazeViewDelegate {
    func mazeView(_: MazeView, configureCell  cell: MazeCellView, forRow row: Int, column: Int) -> MazeCellView
    func numberOfRowsForMazeView(_: MazeView) -> Int
    func numberOfColumnsForMazeView(_: MazeView) -> Int
}

// MARK: - MazeView

class MazeView: UIView {
    
    // MARK: Properties
    
    var delegate: MazeViewDelegate?
    var mazeController: MazeController!
    
    var cellLayer: UIView!
    var cells = [[MazeCellView]]()
    
    var wallColor = UIColor.orangeColor()
    var wallWidth = CGFloat(8)
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCellLayerAndBackground()
    }
    
    convenience init(mazeController: MazeController) {
        self.init()
        self.mazeController = mazeController
        self.setUpCellLayerAndBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpCellLayerAndBackground()
    }
    
    private func setUpCellLayerAndBackground() {
        cellLayer = UIView(frame: self.frame)
        cellLayer.backgroundColor = UIColor.clearColor()
        cellLayer.opaque = false
        addSubview(cellLayer)
        self.backgroundColor = UIColor.blackColor()
    }
    
    // MARK: Create MazeCellViews
    
    func createMazeCells() {
        
        let rowCount = delegate?.numberOfRowsForMazeView(self) ?? 0
        let columnCount = delegate?.numberOfColumnsForMazeView(self) ?? 0
        
        for r in 0..<rowCount {
            var row = [MazeCellView]()
            
            for c in 0..<columnCount {
                let cell = MazeCellView()
                
                if let delegate = delegate {
                    delegate.mazeView(self, configureCell: cell, forRow: r, column: c)
                } else {
                    cell.cellModel = MazeCellModel(top: true, right: true, bottom: true, left: true)
                }
                
                cell.backgroundColor = UIColor.clearColor()
                
                row.append(cell)
                
                cellLayer.addSubview(cell)
            }
            
            cells.append(row)
        }
    }
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        var xPadding: CGFloat = 0
        var yPadding: CGFloat = 0
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        
        let rowCount = delegate?.numberOfRowsForMazeView(self) ?? 0
        let columnCount = delegate?.numberOfColumnsForMazeView(self) ?? 0
        
        let width = (bounds.size.width - (2 * wallWidth)) / CGFloat(columnCount)
        let height = (bounds.size.height - (2 * wallWidth)) / CGFloat(rowCount)
        
        // Get the cell size and the padding required to center the maze in the frame
        if width < height {
            size = width
            yPadding = (bounds.size.height - (size * CGFloat(rowCount))) / 2
        } else {
            size = height
            xPadding = (bounds.size.width - (size * CGFloat(columnCount))) / 2
        }
        
        for r in 0..<rowCount {
            for c in 0..<columnCount {
                let cell = cells[r][c]
                
                x = xPadding + wallWidth + CGFloat(c) * size
                y = yPadding + wallWidth + CGFloat(r) * size
                
                cell.frame = CGRect(x: x, y: y, width: size, height: size)
                cell.wallWidth = wallWidth
                cell.wallColor = wallColor
            }
        }
        
        self.setNeedsDisplay()
        mazeController.repositionObjects()
    }
    
    override func drawRect(rect: CGRect) {
        let rowCount = delegate?.numberOfRowsForMazeView(self) ?? 0
        let columnCount = delegate?.numberOfColumnsForMazeView(self) ?? 0
        
        if rowCount == 0 || columnCount == 0 {
            return
        }
        
        let firstCell = cells.first!.first!.frame
        
        let width = CGFloat(columnCount) * firstCell.size.width
        let height = CGFloat(rowCount) * firstCell.size.height
        
        let rect = CGRect(x: firstCell.origin.x, y: firstCell.origin.y, width: width, height: height)
        let bezierPath = UIBezierPath(CGPath: CGPathCreateWithRect(rect, nil))
        
        wallColor.setStroke()
        bezierPath.lineWidth = wallWidth / 2
        bezierPath.stroke()
        
        super.drawRect(rect)
    }
    
    // MARK: Convenience
    
    func cellForRow(row: Int, column: Int) -> MazeCellView {
        return cells[row][column]
    }
    
    func rows() -> Int {
        return cells.count
    }
    
    func columns() -> Int {
        if cells.count > 0 {
            return cells[0].count
        } else {
            return 0
        }
    }
}