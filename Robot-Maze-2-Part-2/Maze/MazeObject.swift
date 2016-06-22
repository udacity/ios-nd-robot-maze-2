//
//  MazeObject.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - MazeObject

protocol MazeObject {
    var location: MazeLocation { get set }
    var direction: MazeDirection { get set }
    var view: UIView { get set }
    var mazeController: MazeController? { get set }
}

// MARK: - MazeCollidable

protocol MazeCollidable: MazeObject {
    func performActionOnCollision(object: MazeObject)
}