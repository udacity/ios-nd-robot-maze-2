//
//  QueueManager.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import Foundation

// MARK: - QueueManager

class QueueManager {

    // MARK: Properties
    
    static let sharedManager = QueueManager()
    private var lastOperation: NSOperation? = nil
    var operationQueue: NSOperationQueue

    // MARK: Initializers
    
    init() {
        self.operationQueue = NSOperationQueue.mainQueue()
    }
    
    // MARK: Add Dependencies
    
    func addDependentMove(move: MazeMoveOperation) {
        if let lastOperation = lastOperation { move.addDependency(lastOperation) }
        lastOperation = move
        operationQueue.addOperation(move)
    }
}