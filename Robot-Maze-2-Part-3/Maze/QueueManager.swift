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
    fileprivate var lastOperation: Operation? = nil
    var operationQueue: OperationQueue

    // MARK: Initializers
    
    init() {
        self.operationQueue = OperationQueue.main
    }
    
    // MARK: Add Dependencies
    
    func addDependentMove(_ move: MazeMoveOperation) {
        if let lastOperation = lastOperation { move.addDependency(lastOperation) }
        lastOperation = move
        operationQueue.addOperation(move)
    }
}
