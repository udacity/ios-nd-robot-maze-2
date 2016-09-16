//
//  MazeController.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - MazeController

class MazeController {
    
    // MARK: Properties
    var controlCenter: ControlCenter!
    var cellModels: [[MazeCellModel]]!
    var mazeView: MazeView!
    var mazeObjects = [MazeObject]()
    let moveDuration = 0.2
    
    // MARK: Initializers
    
    init(plistFile: String, mazeView: MazeView) {
        self.mazeView = mazeView
        self.mazeView.mazeController = self
        self.mazeView.delegate = self
        cellModels = cellModelsFromPlist(plistFile)
        self.mazeView.createMazeCells()
    }
    
    func cellModelsFromPlist(_ filename: String) -> [[MazeCellModel]] {
        
        var models = [[MazeCellModel]]()
        
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                
                for row in dict["cellData"] as! [AnyObject] {
                    
                    var rowOfModels = [MazeCellModel]()
                    
                    for walls in row as! [[Bool]] {
                        
                        let top = walls[0]
                        let right = walls[1]
                        let bottom = walls[2]
                        let left = walls[3]
                        
                        rowOfModels.append(MazeCellModel(top: top, right: right, bottom: bottom, left: left))
                    }
                    
                    models.append(rowOfModels)
                }
            }
        } else {
            print("Error: Maze plist not found!")
        }
            
        return models
    }
    
    func repositionObjects() {
        for object in mazeObjects {
            object.view.frame = mazeView.cellForRow(object.location.y, column: object.location.x).frame
        }
    }
    
    // MARK: Adding Maze Objects
    
    func addMazeObject(_ obj: MazeObject) {
        
        var object = obj
        
        if object.location.x < 0 || object.location.x >= mazeView.columns() {
            print("MazeObject not added, MazeLocation not in bounds")
            return
        }
        
        if object.location.y < 0 || object.location.y >= mazeView.rows() {
            print("MazeObject not added, MazeLocation not in bounds")
            return
        }
        
        mazeObjects.append(object)
        
        object.mazeController = self
        
        let view = object.view
        mazeView.addSubview(view)
        mazeView.sendSubview(toBack: view)
        object.view.frame = self.mazeView.cellForRow(object.location.y, column: object.location.x).frame
    }
    
    // MARK: Move MazeObjects
    
    func performMazeMoveOperation(_ operation: MazeMoveOperation) {
        let move = operation.move
        let object = operation.object
        
        // This method is called after the robot completes a move or rotates.
        func moveObjectToLocationCompletion(_ operation: MazeMoveOperation, object: MazeObject, move: MazeMove) {
            operation.markAsFinished()
            self.didPerformMove(object, move: move)
        }
        
        if move.rotateDirection == .none {
            let newLocation = MazeLocation(x: object.location.x + move.coords.dx, y: object.location.y + move.coords.dy)
            if objectCanMoveToLocation(object, move: move) {
                moveObjectToLocation(object, newLocation: newLocation) {
                    moveObjectToLocationCompletion(operation, object: object, move: move)
                }
            } else {
                animateObjectNotMovingToLocation(object, direction: move.direction, newLocation: newLocation) {
                    moveObjectToLocationCompletion(operation, object: object, move: move)
                }
            }
        } else {
            rotateObject(object, direction: move.rotateDirection) {
                moveObjectToLocationCompletion(operation, object: object, move: move)
            }
        }
    }
    
    func moveObjectToLocation(_ obj: MazeObject, newLocation: MazeLocation, completionHandler: @escaping () -> Void) {
        
        var object = obj
        
        let newFrame = self.mazeView.cellForRow(newLocation.y, column: newLocation.x).frame
        
        CATransaction.begin()
        
        let moveAnimationX = CABasicAnimation(keyPath: "position.x")
        moveAnimationX.fromValue = object.view.layer.position.x
        moveAnimationX.toValue = self.mazeView.cellForRow(newLocation.y, column: newLocation.x).layer.position.x
        moveAnimationX.duration = moveDuration
        moveAnimationX.fillMode = kCAFillModeForwards
        moveAnimationX.isRemovedOnCompletion = true
        
        let moveAnimationY = CABasicAnimation(keyPath: "position.y")
        moveAnimationY.fromValue = object.view.layer.position.y
        moveAnimationY.toValue = self.mazeView.cellForRow(newLocation.y, column: newLocation.x).layer.position.y
        moveAnimationY.duration = moveDuration
        moveAnimationX.fillMode = kCAFillModeForwards
        moveAnimationY.isRemovedOnCompletion = true
        
        CATransaction.setCompletionBlock({
            object.view.frame = newFrame
            object.location = newLocation
            object.view.layer.removeAllAnimations()
            completionHandler()
        })
        
        object.view.layer.add(moveAnimationX, forKey: "x_position")
        object.view.layer.add(moveAnimationY, forKey: "y_position")
        
        CATransaction.commit()
    }
    
    func rotateObject(_ object: MazeObject, direction: RotateDirection, completionHandler: @escaping () -> Void) {
        
        UIView.animate(withDuration: moveDuration, animations: { () -> Void in
            object.view.transform = object.view.transform.rotated(by: (direction == RotateDirection.right) ? CGFloat(M_PI_2) : CGFloat(-M_PI_2))
            }) { _ in
                completionHandler()
        }
    }
    
    fileprivate func animateObjectNotMovingToLocation(_ object: MazeObject, direction: MazeDirection, newLocation: MazeLocation, completionHandler: @escaping () -> Void) {
        
        if object is ComplexRobotObject {
            let robot = object as! ComplexRobotObject
            
            let shakeProportion: CGFloat = 0.2
            let originalFrame = robot.view.frame
            
            var targetFrame = robot.view.frame
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            
            switch(direction) {
            case MazeDirection.up:
                dy = robot.view.frame.width * shakeProportion * -1.0
            case MazeDirection.down:
                dy = robot.view.frame.width * shakeProportion
            case MazeDirection.left:
                dx = robot.view.frame.width * shakeProportion * -1.0
            case MazeDirection.right:
                dx = robot.view.frame.width * shakeProportion
            }
            
            targetFrame.origin.x += dx
            targetFrame.origin.y += dy
            
            UIView.animate(withDuration: moveDuration / 3, delay: 0, options: UIViewAnimationOptions.autoreverse, animations: {
                robot.view.frame = targetFrame
            }, completion: { _ in
                robot.view.frame = originalFrame
                completionHandler()
            })
        }
    }
    
    // MARK: Collision Checking
    
    // Here's where we notify the control center that the move is complete.
    func didPerformMove(_ object: MazeObject, move: MazeMove) {
        for mazeObject in mazeObjects {
            if let mazeObject = mazeObject as? MazeCollidable {
                if mazeObject.view != object.view && object.location == mazeObject.location {
                    mazeObject.performActionOnCollision(object)
                    print("The robot reached the star!")
                    printTimestamp()
                    break
                } else {
                    self.controlCenter.previousMoveIsFinished(object as! ComplexRobotObject)
                }
            }
        }
    }
    
    func printTimestamp() {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        print(timestamp)
    }
    
    // MARK: Convenience
     
    fileprivate func objectCanMoveToLocation(_ object: MazeObject, move: MazeMove) -> Bool {
        
        let cell = cellModels[object.location.y][object.location.x]
        
        switch(move.direction) {
        case .up:
            return !cell.top
        case .down:
            return !cell.bottom
        case .left:
            return !cell.left
        case .right:
            return !cell.right
        }
    }
}

// MARK: - MazeViewDelegate

extension MazeController: MazeViewDelegate {
    
    func mazeView(_: MazeView, configureCell  cell: MazeCellView, forRow row: Int, column: Int) -> MazeCellView {
        cell.cellModel = cellModels[row][column]
        return cell
    }
    
    func numberOfRowsForMazeView(_: MazeView) -> Int {
        return cellModels.count
    }
    
    func numberOfColumnsForMazeView(_: MazeView) -> Int {
        return (cellModels.first != nil) ? cellModels.first!.count : 0
    }
}

// MARK: - Random Mouse Methods

extension MazeController {

    func currentCell(_ robot: ComplexRobotObject) -> MazeCellModel {
        let cell = self.cellModels[robot.location.y][robot.location.x]
        return cell
    }


}
