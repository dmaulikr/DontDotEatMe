//
//  GameScene.swift
//  NewDotGame
//
//  Created by Matthew Keesey on 10/14/16.
//  Copyright (c) 2016 Matthew Keesey. All rights reserved.
//

import SpriteKit
//import GameController

class GameScene: SKScene {
    
    var counter = 0 // testing reasons
    
    var score: Float = 0.1 // // HeadUpDisplay
   
    // Persist the initial touch position of the remote
    var touchPositionX: CGFloat = 0.0
    var touchPositionY: CGFloat = 0.0
    let sprite = SKSpriteNode(imageNamed: "orangeCircle")
    
    let labelScore = SKLabelNode(fontNamed: "ArialMT") // label to display the score
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //drawCircle()
        createHUD()
        setUpControllerObservers()
        connectControllers()
        
        drawSprite()
        
        sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(sprite)
        
        
        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
        tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
        self.view?.addGestureRecognizer(tap)
        
        createSmallDot()
        
        // Todo List
        // 1. a small dot(10px 10px) - Completed
        // 2. Detect a collision between player dot and dot on the board
        // 3. Clear a dot once it is hit - Currently working
        // 4. Add it to score - You get a 0.1 points everytime you hit a dot

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            touchPositionX = touch.locationInNode(self).x
            touchPositionY = touch.locationInNode(self).y
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if touchPositionX != 0.0 && touchPositionY != 0.0 {
                
                // Calculate the movement on the remote
                let deltaX = touchPositionX - location.x
                let deltaY = touchPositionY - location.y
                
                // Calculate the new Sprite position
                var x = sprite.position.x - deltaX
                var y = sprite.position.y - deltaY
                
                // Check if the sprite will leave the screen
                if x < 0 {
                    x = 0
                } else if x > self.frame.width {
                    x = self.frame.width
                }
                if y < 0 {
                    y = 0
                } else if y > self.frame.height {
                    y = self.frame.height
                }
                // Move the sprite
                sprite.position = CGPoint(x: x, y: y)
                
            }
            // Persist latest touch position
            touchPositionY = location.y
            touchPositionX = location.x
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Update the score
        updateHUD()
        
        // Resize the sprite depending on the score
        drawSprite()
        
        // Looking for a collision between two dots
        
    }
    
    func createSmallDot(){
        // create a dot that is 10px by 10px and is yellow
        let smallDot = SKSpriteNode(imageNamed: "orangeCircle")
        smallDot.position = CGPointMake(517, 400)
        smallDot.size = CGSize(width: 10, height: 10)
        self.addChild(smallDot)
    }
    
    func drawSprite(){
        sprite.yScale = CGFloat(score)
        sprite.xScale = CGFloat(score)
        
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) { // touchpad tapped add 0.1 to the score
        score = score + 0.1
    }
    
    func createHUD(){ // Creates the scoreboard in the upper left corner
        
        labelScore.fontSize = 35;
        labelScore.fontColor = .whiteColor()
        labelScore.position = CGPoint(x:frame.minX + 100, y:frame.maxY - 100)
        addChild(labelScore)
        
        updateHUD()
        
    }
    
    func updateHUD(){ // Update the score and times by 10 to show the as an integer
        labelScore.text = "Score: " + "\(score * 10) "
    }
    
    func drawCircle(){
        let bg = SKSpriteNode(imageNamed: "orangeCircle")
        bg.position = CGPointMake(517, 400)
        bg.size = CGSize(width: 100, height: 100)
        self.addChild(bg)
        
        // Draw a circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:200, y:200),
                                      radius: CGFloat(20),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(M_PI * 2),
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        shapeLayer.fillColor = UIColor.redColor().CGColor
        
    
    }
    
    
}
