//
//  GameViewController.swift
//  CrappyBirds
//
//  Created by Daniel Hauagge on 3/19/16.
//  Copyright (c) 2016 Daniel Hauagge. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    let scene = GameScene(fileNamed:"GameScene")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideButtons()
        
        if scene != nil {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene!.scaleMode = .AspectFill
            scene!.viewController = self
            
            skView.presentScene(scene)
        }
    }
    
    
    func showButtons() {
        resumeButton.hidden = false
        menuButton.hidden = false
    }
    
    func hideButtons() {
        resumeButton.hidden = true
        menuButton.hidden = true
    }
    
    @IBAction func resumeButtonPressed(sender: AnyObject) {
        hideButtons()
        scene!.restart()
    }
    
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        hideButtons()
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenNavigationViewController")
        presentViewController(nextViewController!, animated: true, completion: nil)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
