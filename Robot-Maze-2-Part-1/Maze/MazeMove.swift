//
//  MazeMovez.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/17/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

// MARK: - MazeMove

struct MazeMove {
    
    let coords: Move // abstracted dx/dy to Move for learning demonstration
    
    var rotateDirection: RotateDirection
    var direction: MazeDirection {
        get {
            switch(coords.dx, coords.dy) {
            case (0, -1):
                return .up
            case (0, 1):
                return .down
            case (-1, 0):
                return .left
            case (1, 0):
                return .right
            default:
                assert(false, "Invalid MazeDirection, Invalid RobotMove")
            }
        }
    }
}
