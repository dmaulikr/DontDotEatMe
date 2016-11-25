//
//  GameScene.swift
//  NewDotGame
//
//  Created by Matthew Keesey on 10/14/16.
//  Copyright (c) 2016 Matthew Keesey. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene {
    
    var counter = 0 // testing reasons
    var score: Float = 0.1 // // HeadUpDisplay
    var gamePad:GCController?
    // Persist the initial touch position of the remote
    var touchPositionX: CGFloat = 0.0
    var touchPositionY: CGFloat = 0.0
    let dotSpeed: CGFloat = 1.85
    
    let playerDot = SKSpriteNode(imageNamed: "playerFace")
    var smallDots:[SKSpriteNode] = []
    let maxDots:Int = 50
    
    let labelScore = SKLabelNode(fontNamed: "ArialMT") // label to display the score
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //drawCircle()
        createHUD()
        setUpControllerObservers()
        connectControllers()
        
        createSmallDot()
        
        
        drawSprite()
        playerDot.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(playerDot)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapped(_:)))
        tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue as Int)]
        self.view?.addGestureRecognizer(tap)
       

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchPositionX = touch.location(in: self).x
            touchPositionY = touch.location(in: self).y
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if touchPositionX != 0.0 && touchPositionY != 0.0 {
                
                // Calculate the movement on the remote
                let deltaX = touchPositionX - location.x
                let deltaY = touchPositionY - location.y
                
                // Calculate the new Sprite position
                var x = playerDot.position.x - deltaX
                var y = playerDot.position.y - deltaY
                
                // Check if the playerDot will leave the screen
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
                // Move the playerDot
                playerDot.position = CGPoint(x: x, y: y)
                
            }
            // Persist latest touch position
            touchPositionY = location.y
            touchPositionX = location.x
        }
    }
   
    func moveDot(_ deltaX: CGFloat, deltaY: CGFloat) {
        
        var x = playerDot.position.x + (deltaX * dotSpeed)
        var y = playerDot.position.y + (deltaY * dotSpeed)
        
        // Check if the playerDot will leave the screen
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
        // Move the playerDot
        playerDot.position = CGPoint(x: x, y: y)

    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        
        //Update the score
        updateHUD()
        
        
        
        // Resize the playerDot depending on the score
        if(gamePad != nil){
            let GC:GCController = gamePad! // self.getController()
            //GC.extendedGamepad
            if(GC.extendedGamepad != nil ){
                print(GC.extendedGamepad?.leftThumbstick.xAxis.value,GC.extendedGamepad?.leftThumbstick.yAxis.value)
                self.moveDot(CGFloat((GC.extendedGamepad?.leftThumbstick.xAxis.value)!),deltaY: CGFloat((GC.extendedGamepad?.leftThumbstick.yAxis.value)!))
            }else{
                print("cannot find extendedgamepad")
            }
        }
        drawSprite()
        
        // Looking for a collision between two dots
        checkSmallDotCollide()
        

        
    }
    func checkSmallDotCollide(){
        var okDots:[SKSpriteNode] = []
        //print(CGFloat(1 + 1 * score))
        for smallDot in smallDots {
            /*
            var Ay = smallDot.position.y + (smallDot.size.height + CGFloat(1 + 1 * score))
            var Bx = smallDot.position.x + (smallDot.size.width  + CGFloat(1 + 1 * score))
            var Cy = smallDot.position.y - (smallDot.size.height - CGFloat(1 + 1 * score))
            var Dx = smallDot.position.x - (smallDot.size.width - CGFloat(1 + 1 * score))
            //print(Ay,Bx,Cy,Dx)
            */
            var Ay = smallDot.position.y + smallDot.size.height * 2
            var Bx = smallDot.position.x + smallDot.size.width * 2
            var Cy = smallDot.position.y - smallDot.size.height * 2
            var Dx = smallDot.position.x - smallDot.size.width * 2
            
            
            
            if(playerDot.position.x <= Bx && playerDot.position.x >= Dx && playerDot.position.y <= Ay && playerDot.position.y >= Cy
                ){
                //print("playerDot ate smallDot")
                /*
                // move smallDot to random point after eaten
                var Ry = Int(arc4random_uniform(100) + 50)
                if(arc4random_uniform(2) == 0){
                    Ry *= -1
                }
                var Rx = Int(arc4random_uniform(100) + 50)
                if(arc4random_uniform(2) == 0){
                    Rx *= -1
                }
                smallDot.position.x += CGFloat(Rx)
                smallDot.position.y += CGFloat(Ry)
                
                */
                // make score increase
                score = score + 0.1
                print(score)
                // erase smallDot
                smallDot.removeFromParent()
            }else{
                okDots.append(smallDot)
            }
        }//end for smallDots
        smallDots = okDots
    }
    func createSmallDot(){
        // create a dot that is 10px by 10px and is yellow
        for __ in 0..<maxDots{
            var sd = SKSpriteNode(imageNamed: "orangeCircle")
            var Ry = Int(arc4random_uniform(UInt32(self.frame.height)))
            if(arc4random_uniform(2) == 0){
                //Ry *= -1
            }
            var Rx = Int(arc4random_uniform(UInt32(self.frame.width)))
            if(arc4random_uniform(2) == 0){
                //Rx *= -1
            }
            sd.position.x += CGFloat(Rx)
            sd.position.y += CGFloat(Ry)
            //sd.position = CGPoint(x: 517, y: 400)
            sd.size = CGSize(width: 10, height: 10)
            smallDots.append(sd)
            
        }
        for sprite in smallDots {
            addChild(sprite)
        }
        
    }
    
    func drawSprite(){
        playerDot.yScale = CGFloat(score)
        playerDot.xScale = CGFloat(score)
        
    }
    
    
    func tapped(_ gesture: UITapGestureRecognizer) { // touchpad tapped add 0.1 to the score
        //score = score + 0.1
    }
    
    func createHUD(){ // Creates the scoreboard in the upper left corner
        
        labelScore.fontSize = 35;
        labelScore.fontColor = SKColor.white
        labelScore.position = CGPoint(x:frame.minX + 100, y:frame.maxY - 100)
        addChild(labelScore)
        
        updateHUD()
        
    }
    
    func updateHUD(){ // Update the score and times by 10 to show the as an integer
        labelScore.text = "Score: " + "\(score * 10) "
    }
    
    func drawCircle(){
        let bg = SKSpriteNode(imageNamed: "orangeCircle")
        bg.position = CGPoint(x: 517, y: 400)
        bg.size = CGSize(width: 100, height: 100)
        self.addChild(bg)
        
        // Draw a circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:200, y:200),
                                      radius: CGFloat(20),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(M_PI * 2),
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
    
    }
    
    
}
