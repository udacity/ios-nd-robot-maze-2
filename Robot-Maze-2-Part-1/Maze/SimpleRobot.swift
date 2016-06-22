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
        move(MazeDirection.Up, moves: 1)
    }
    
    func moveDown() {
        move(MazeDirection.Down, moves: 1)
    }
    
    func moveLeft() {
        move(MazeDirection.Left, moves: 1)
    }
    
    func moveRight() {
        move(MazeDirection.Right, moves: 1)
    }
}