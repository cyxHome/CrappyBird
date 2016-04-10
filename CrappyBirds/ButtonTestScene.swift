//
//  ButtonTestScene.swift
//  CrappyBirds
//
//  Created by caoyuxin on 3/19/16.
//

import Foundation
import SpriteKit

class ButtonTestScene: SKScene {
    var button: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        // Create a simple red rectangle that's 100x44
        button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        // Put it in the center of the scene
        button.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if button.containsPoint(location) {
                print("tapped!")
            }
        }
    }
}