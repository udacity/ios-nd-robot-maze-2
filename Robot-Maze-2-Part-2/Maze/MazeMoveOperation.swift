//
//  MazeMoveOperation.swift
//  Maze
//
//  Created by Jarrod Parkes on 6/15/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

// MARK: - MazeMoveOperation

class MazeMoveOperation: NSOperation {

    // MARK: Properties
    
    private let mazeController: MazeController
    private var isFinished: Bool
    
    let move: MazeMove
    let object: MazeObject

    // MARK: Initializers
    
    init(object: MazeObject, move: MazeMove, mazeController: MazeController) {
        self.object = object
        self.move = move
        self.mazeController = mazeController
        self.isFinished = false
        super.init()
    }

    // MARK: NSOperation overrides
    
    override var finished: Bool {
        get {
            return isFinished
        }
    }
    
    override func start() {
        mazeController.performMazeMoveOperation(self)
    }
    
    // MARK: KVO Convenience
    
    func markAsFinished() {
        willChangeValueForKey("isFinished")
        isFinished = true
        didChangeValueForKey("isFinished")
    }
}