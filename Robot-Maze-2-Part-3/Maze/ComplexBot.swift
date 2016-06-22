//
//  ComplexRobot.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

// MARK: - ComplexRobot
// Used to give students a clean interface 😉!

protocol ComplexRobot {
    func rotateRight()
    func rotateLeft()
    func move()
    func move(_ moves: Int)
}

// MARK: - ComplexRobotObject

class ComplexRobotObject: MazeActor, ComplexRobot {
    
    // MARK: Moves
        
    func rotateRight() {
        rotate(.right)
    }
    
    func rotateLeft() {
        rotate(.left)
    }
    
    func move() {
        move(direction, moves: 1)
    }
    
    func move(_ moves: Int) {
        move(direction, moves: moves)
    }
}
