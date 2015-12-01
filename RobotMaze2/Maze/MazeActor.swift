//
//  MovingObject.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - MazeActor

class MazeActor: MazeObject {
    
    // MARK: Properities
    
    var location: MazeLocation
    var direction: MazeDirection
    var view: UIView
    var mazeController: MazeController?
    
    let objectSize = CGSize(width: 50, height: 50)
    let queueManager = QueueManager.sharedManager
    
    // MARK: Initializers
    
    init(location: MazeLocation, direction: MazeDirection) {        
        self.location = location
        self.direction = direction
        
        self.view = SimpleRobotView()
        self.view.opaque = false
        
        if self.direction != MazeDirection.Up {
            self.view.transform = CGAffineTransformRotate(self.view.transform, CGFloat(M_PI_2) * CGFloat(self.direction.rawValue))
        }
    }
    
    init(location: MazeLocation, direction: MazeDirection, imagePath: String) {
        self.location = location
        self.direction = direction
        
        self.view = UIView(frame: CGRectMake(0, 0, objectSize.width, objectSize.height))
        self.view.opaque = false
        
        if let image = UIImage(named: imagePath) {
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.frame
            self.view.addSubview(imageView)
        }
        
        if self.direction != MazeDirection.Up {
            self.view.transform = CGAffineTransformRotate(self.view.transform, CGFloat(M_PI_2) * CGFloat(self.direction.rawValue))
        }
    }
    
    // MARK: Enqueue MazeMovesOperation (NSOperation)
    
    func rotate(rotateDirection: RotateDirection, completionHandler: (() -> Void)? = nil) {
        if rotateDirection == RotateDirection.Left {
            if direction.rawValue > 0 { direction = MazeDirection(rawValue: direction.rawValue - 1)! }
            else { direction = MazeDirection.Left }
        } else if rotateDirection == RotateDirection.Right {
            if direction.rawValue < 3 { direction = MazeDirection(rawValue: direction.rawValue + 1)! }
            else { direction = MazeDirection.Up }
        }
        
        let move = MazeMove(coords: Move(dx: 0, dy: 0), rotateDirection: rotateDirection)
        enqueueMove(move, completionHandler: completionHandler)
    }
    
    func move(moveDirection: MazeDirection, moves: Int, completionHandler: (() -> Void)? = nil) {
        if moveDirection != self.direction {
            var movesToRotate = moveDirection.rawValue - self.direction.rawValue
            if movesToRotate == 3 { movesToRotate = -1 }
            else if movesToRotate == -3 { movesToRotate = 1 }
            for _ in 0..<abs(movesToRotate) {
                rotate((movesToRotate > 0) ? RotateDirection.Right : RotateDirection.Left, completionHandler: completionHandler)
            }
        }
        
        let dx = (moveDirection == MazeDirection.Right) ? 1 : ((moveDirection == MazeDirection.Left) ? -1 : 0)
        let dy = (moveDirection == MazeDirection.Up) ? -1 : ((moveDirection == MazeDirection.Down) ? 1 : 0)
        
        for var i = 0; i < moves; ++i {
            let move = MazeMove(coords: Move(dx: dx, dy: dy), rotateDirection: .None)
            enqueueMove(move, completionHandler: completionHandler)
        }
    }
    
    func enqueueMove(move: MazeMove, completionHandler: (() -> Void)? = nil) {
        guard let mazeController = mazeController else { return }
        
        let operation = MazeMoveOperation(object: self, move: move, mazeController: mazeController)
        queueManager.addDependentMove(operation)
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
}

extension MazeActor: Hashable {
    var hashValue: Int {
        return self.view.hashValue
    }
}