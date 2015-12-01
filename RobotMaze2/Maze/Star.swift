//
//  Star.swift
//  Maze
//
//  Created by Jarrod Parkes on 8/14/15.
//  Copyright © 2015 Udacity, Inc. All rights reserved.
//

import UIKit

// MARK: - Star

class Star: MazeCollidable {

    // MARK: Properties
    
    var location: MazeLocation
    var direction: MazeDirection
    var view: UIView
    var mazeController: MazeController?
    var actionHandler: ((MazeObject) -> Void)? = nil
    
    let objectSize = CGSize(width: 50, height: 50)

    // MARK: Initializers
    
    init(location: MazeLocation = MazeLocation(x: 3, y: 2), imagePath: String = "star.png") {
        self.location = location
        self.direction = MazeDirection.Up
        self.view = UIView(frame: CGRectMake(0, 0, objectSize.width, objectSize.height))
        
        if let image = UIImage(named: imagePath) {
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.frame
            self.view.addSubview(imageView)
        }
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0.0
        rotate.toValue = ((360.0 * M_PI) / 180.0)
        rotate.duration = 2.0
        rotate.repeatCount = 1e100
        self.view.layer.addAnimation(rotate, forKey: "360")
    }
    
    // MARK: MazeCollidable
    
    func performActionOnCollision(object: MazeObject) {
        if let actionHandler = actionHandler {
            actionHandler(object)
        }
    }
}