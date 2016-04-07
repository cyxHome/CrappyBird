//
//  GameScene.swift
//  CrappyBirds
//
//  Created by Daniel Hauagge on 3/19/16.
//  Copyright (c) 2016 Daniel Hauagge. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background : SKSpriteNode!
    
    var bird : SKSpriteNode!
    var birdTextureAtlas = SKTextureAtlas(named: "player.atlas")
    var birdTextures = [SKTexture]()
    
    var explosionTextureAtlas = SKTextureAtlas(named: "explosion.atlas")
    var explosionTextures = [SKTexture]()
    
    var floors = [SKSpriteNode]()
    var ceil = SKSpriteNode()

    
    var pipes = [SKSpriteNode]()
    let pipeSpacing = CGFloat(800)
    
    let BIRD_CAT  : UInt32 = 0x1 << 0
    let FLOOR_CAT : UInt32 = 0x1 << 1
    let CEIL_CAT  : UInt32 = 0x1 << 2
    let TOP_PIPE_CAT  : UInt32 = 0x1 << 3
    let BOTTOM_PIPE_CAT  : UInt32 = 0x1 << 4
    
    var isRunning = true
    
    var bottomPipeY = CGFloat(0)
    var topPipeY = CGFloat(0)
    
    var lastUpdateTime = CFAbsoluteTimeGetCurrent()
    
    let pipeSpace = CGFloat(100)
    let pipeShiftStart = CGFloat(200)
    let pipeShiftEnd = CGFloat(-200)
    
    var passPipeCount = 0
    var button: SKNode! = nil
    var backToMainButton : SKNode! = nil
    
    var restartLabel : SKLabelNode! = nil
    var backToMainLabel : SKLabelNode! = nil
    var countLabel : SKLabelNode! = SKLabelNode.init()
    
    var pipeAtRightOfMiddleScreen = [true, true]
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !isRunning {
            return
        }
        print("something colided")
        isRunning = false
        
        let explosion = SKAction.animateWithTextures(explosionTextures, timePerFrame: 0.05)
    
        let removeBird = SKAction.removeFromParent()
        let actionSeq = SKAction.sequence([explosion, removeBird])
        bird.runAction(actionSeq, completion: {
            self.restartLabel = SKLabelNode.init()
            self.restartLabel.text = "Restart"
            self.restartLabel.fontSize = 40
            self.backToMainLabel = SKLabelNode.init()
            self.backToMainLabel.text = "Back To Main"
            self.backToMainLabel.fontSize = 40
            self.button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 300, height: 100))
            // Put it in the center of the scene
            self.button.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
            self.button.addChild(self.restartLabel)
            self.button.zPosition = 1000
            self.button.position.y += 100
            self.addChild(self.button)
            self.backToMainButton = SKSpriteNode(color: SKColor.brownColor(), size: CGSize(width: 300, height: 100))
            self.backToMainButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
            self.backToMainButton.addChild(self.backToMainLabel)
            self.backToMainButton.zPosition = 1000
            self.addChild(self.backToMainButton)
        })
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func addBird() {
        // Bird
        for texName in explosionTextureAtlas.textureNames.sort() {
            let tex = explosionTextureAtlas.textureNamed(texName)
            explosionTextures.append(tex)
        }
        for texName in birdTextureAtlas.textureNames.sort() {
            let tex = birdTextureAtlas.textureNamed(texName)
            birdTextures.append(tex)
        }
        bird = SKSpriteNode(texture: birdTextures[0])
        bird.size.width /= 10
        bird.size.height /= 10
        bird.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        let birdAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(birdTextures, timePerFrame: 0.1))
        bird.runAction(birdAnimation)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.restitution = 0.0
        bird.physicsBody?.categoryBitMask = BIRD_CAT
        bird.physicsBody?.collisionBitMask = FLOOR_CAT | CEIL_CAT | TOP_PIPE_CAT | BOTTOM_PIPE_CAT
        bird.physicsBody?.contactTestBitMask = TOP_PIPE_CAT | BOTTOM_PIPE_CAT
        
        let particlesPath = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        let particles = NSKeyedUnarchiver.unarchiveObjectWithFile(particlesPath!) as!
            SKEmitterNode!
        particles.position.x -= 65
        bird.addChild(particles)
        
        addChild(bird)
    }
    
    func cleanUpPipes() {
        for pipe in pipes {
            pipe.removeFromParent()
        }
        pipes.removeAll()
    }
    
    func addPipesIntoView() {

        // Pipes
        for i in 0 ..< 2 {
            let offset = randomBetweenNumbers(pipeShiftStart, secondNum: pipeShiftEnd)
            
            // Bottom
            let bottomPipe = SKSpriteNode(imageNamed: "bottomPipe")
            bottomPipe.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
            bottomPipe.size.width *= 0.5
            
            bottomPipe.position.y = CGRectGetMaxY(floors[i].frame) + offset - pipeSpace/2
            bottomPipe.position.x = CGFloat(i + 2) * pipeSpacing
            bottomPipe.physicsBody = SKPhysicsBody(texture: bottomPipe.texture!, size: bottomPipe.size)
            bottomPipe.physicsBody?.dynamic = false
            bottomPipe.physicsBody?.categoryBitMask = BOTTOM_PIPE_CAT
            bottomPipeY = bottomPipe.position.y
            addChild(bottomPipe)
            pipes.append(bottomPipe)
            
            // Top
            let topPipe = SKSpriteNode(imageNamed: "topPipe")
            topPipe.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
            topPipe.size.width *= 0.5
            
            topPipe.position.y = CGRectGetMaxY(frame) + offset + pipeSpace/2
            topPipe.position.x = CGFloat(i + 2) * pipeSpacing
            topPipe.physicsBody = SKPhysicsBody(texture: topPipe.texture!, size: topPipe.size)
            topPipe.physicsBody?.dynamic = false
            topPipe.physicsBody?.categoryBitMask = TOP_PIPE_CAT
            topPipeY = topPipe.position.y
            addChild(topPipe)
            pipes.append(topPipe)
        }
    }
    
    func addFloor() {
        for i in 0 ..< 3 {
            let floor = SKSpriteNode(imageNamed: "floor")
            // more the origin to the bottom left
            floor.anchorPoint = CGPointZero
            floor.position = CGPointMake(CGFloat(i) * floor.size.width, 0)
            
            var rect = floor.frame
            rect.origin.x = 0
            rect.origin.y = 0
            floor.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
            floor.physicsBody?.dynamic = false
            floor.physicsBody?.categoryBitMask = FLOOR_CAT
            
            floors.append(floor)
            addChild(floor)
        }
    }
    
    func addCeil() {
        ceil.size.width = frame.size.width
        ceil.size.height = 1
        ceil.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        ceil.physicsBody?.categoryBitMask = CEIL_CAT
        
        addChild(ceil)
    }
    
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        // Keep bird from flying off screen
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        
        // Background
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        background.zPosition = -1000
        addChild(background)
        
        // Bird
        addBird()
        
        // Floor
        addFloor()
        
        // Ceil
        addCeil()
        
        // Pipes
        addPipesIntoView()
        
        countLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + 300)
        countLabel.text = String(passPipeCount)
        countLabel.fontColor = SKColor.redColor()
        countLabel.fontSize = 50
        countLabel.zPosition = 1000
        addChild(countLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if button != nil && button.containsPoint(location) {
                restart()
            }
            else if backToMainButton != nil && backToMainButton.containsPoint(location) {
                backToMain()
            }
        }
    }
    
    func backToMain() {
        button.removeFromParent()
        button = nil
        backToMainButton.removeFromParent()
        backToMainButton = nil
    }
    
    func restart() {
        isRunning = true
        button.removeFromParent()
        button = nil
        backToMainButton.removeFromParent()
        backToMainButton = nil
        addBird()
        cleanUpPipes()
        addPipesIntoView()
        passPipeCount = 0
        countLabel.text = String(passPipeCount)
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if isRunning {
            
            let timeSinceLastUpdate = CGFloat((currentTime - lastUpdateTime) / 0.03)
        
            lastUpdateTime = currentTime
        
            print(timeSinceLastUpdate)
        
            if timeSinceLastUpdate > 2 || timeSinceLastUpdate < 0 {
                return
            }


            bird.position.x = CGRectGetMidX(frame)
            
            // Move floor
            let floorSpeed = CGFloat(4)
            for floor in floors {
                floor.position.x -= floorSpeed * timeSinceLastUpdate
                
                if floor.position.x < -floor.size.width * 0.6 {
                    floor.position.x += 2*floor.size.width
                }
            }
            
            
            // Move pipes
            let pipeSpeed = CGFloat(5 + Float(passPipeCount) * 0.3)
            for i in 0 ..< 2 {
                
                let offset = randomBetweenNumbers(pipeShiftStart, secondNum: pipeShiftEnd)
                
                let bottomPipe = pipes[2*i]
                let topPipe = pipes[2*i+1]
                
                bottomPipe.position.x -= pipeSpeed * timeSinceLastUpdate
                topPipe.position.x -= pipeSpeed * timeSinceLastUpdate
                
                if bottomPipe.position.x < -bottomPipe.size.width * 0.6 {
                    bottomPipe.position.x += 2 * pipeSpacing
                    bottomPipe.position.y = CGRectGetMaxY(floors[i].frame) + offset - pipeSpace/2
                    topPipe.position.x += 2 * pipeSpacing
                    topPipe.position.y = CGRectGetMaxY(frame) + offset + pipeSpace/2
                    pipeAtRightOfMiddleScreen[i] = true
                }
                
            }
            
            for i in 0 ..< 2 {
                
                // pipe pass the bird from right to left
                if pipeAtRightOfMiddleScreen[i] && pipes[2*i].position.x < bird.position.x {
                    pipeAtRightOfMiddleScreen[i] = false
                    passPipeCount++
                    countLabel.text = String(passPipeCount)
                }
                
            }
            
            
        }
        
        
        
    }
}
