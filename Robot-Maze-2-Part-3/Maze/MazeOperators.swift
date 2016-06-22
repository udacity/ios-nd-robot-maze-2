//
//  MazeOperators.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

func ==(left: MazeLocation, right: MazeLocation) -> Bool {
    return left.x == right.x && left.y == right.y
}

func ==(lhs: MazeActor, rhs: MazeActor) -> Bool {
    return (lhs.location == rhs.location) && (lhs.direction == rhs.direction) && (lhs.view == rhs.view)
}