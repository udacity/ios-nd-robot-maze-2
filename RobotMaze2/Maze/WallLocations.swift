//
//  WallLocations.swift
//  Maze
//
//  Created by Gabrielle Miller-Messner on 11/6/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import Foundation

extension ControlCenter {
    
    func isFacingWall(robot: ComplexRobotObject, direction: MazeDirection) -> Bool {
        
        let cell = mazeController.currentCell(robot)
        var isWall: Bool = false
        
        // Step 1.1a
        // TODO: Write a switch statement handling all possible values of direction. The first case has been done for you. Uncomment the code and add the remaining cases!
        //        switch(direction) {
        //        case .Up:
        //            if cell.top {
        //                isWall = true
        //            }
        //
        //        }
        
        // Step 1.1b
        // TODO: Return a Bool that represents whether the robot is currently facing a wall. You will need to change the placeholder return statement below.
        
        
        // Placeholder
        return false
    }
}