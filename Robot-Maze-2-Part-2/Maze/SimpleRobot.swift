//
//  SimpleRobot.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

// MARK: - SimpleRobot
// Used to give students a clean interface 😉!

protocol SimpleRobot {
    func moveUp()
    func moveDown()
    func moveLeft()
    func moveRight()
}

// MARK: - SimpleRobotObject

class SimpleRobotObject: MazeActor, SimpleRobot {
    
    // MARK: Moves
    
    func moveUp() {
        move(MazeDirection.up, moves: 1)
    }
    
    func moveDown() {
        move(MazeDirection.down, moves: 1)
    }
    
    func moveLeft() {
        move(MazeDirection.left, moves: 1)
    }
    
    func moveRight() {
        move(MazeDirection.right, moves: 1)
    }
}
