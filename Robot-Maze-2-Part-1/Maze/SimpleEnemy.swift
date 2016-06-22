//
//  SimpleEnemy.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

// MARK: - SimpleEnemy

private class SimpleEnemy: MazeActor {
    
    // MARK: Properties
    
    var fromLocation: MazeLocation
    var toLocation: MazeLocation
    var moves = [MazeMove]()
    var hasMoved = false
    
    // MARK: Initializers
    
    init(fromLocation: MazeLocation, toLocation: MazeLocation, imagePath: String = "robot.png") {
        self.fromLocation = fromLocation
        self.toLocation = toLocation

        var direction: MazeDirection!
        if self.fromLocation.y < self.toLocation.y {
            direction = MazeDirection.Down
        } else if self.fromLocation.y > self.toLocation.y {
            direction = MazeDirection.Up
        } else if self.fromLocation.x < self.toLocation.x {
            direction = MazeDirection.Right
        } else if self.fromLocation.x > self.toLocation.x {
            direction = MazeDirection.Left
        } else {
            assertionFailure("Direction must be on at least one same axis")
        }
        
        super.init(location: fromLocation, direction: direction, imagePath: imagePath)
    }

    // MARK: Moves
    
    func move() {
        if (self.location == self.fromLocation || self.location == self.toLocation) && hasMoved {
            self.rotate(RotateDirection.Right) {
                self.rotate(RotateDirection.Right) {
                    self.move(self.direction, moves: 1) {
                        self.move()
                    }
                }
            }
        } else {
            self.move(self.direction, moves: 1) {
                self.move()
            }
        }
        
        hasMoved = true
    }
    
    override func enqueueMove(move: MazeMove, completionHandler: (() -> Void)? = nil) {
        if move.rotateDirection == .None {
            let newLocation = MazeLocation(x: self.location.x + move.coords.dx, y: self.location.y + move.coords.dy)
            mazeController?.moveObjectToLocation(self, newLocation: newLocation) {
                self.mazeController?.didPerformMove(self, move: move)
                if let completionHandler = completionHandler { completionHandler() }
            }
        } else {
            mazeController?.rotateObject(self, direction: move.rotateDirection) {
                self.mazeController?.didPerformMove(self, move: move)
                if let completionHandler = completionHandler { completionHandler() }
            }
        }
    }
}