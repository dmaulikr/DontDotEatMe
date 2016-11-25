//
//  GameScene_Controllers.swift
//  NewDotGame
//
//  Created by Matthew Keesey on 10/14/16.
//  Copyright © 2016 Matthew Keesey. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {
    
    
    
    func setUpControllerObservers(){
        
        print("func setUpControllerObservers")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectControllers", name: GCControllerDidConnectNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDisconnected", name: GCControllerDidDisconnectNotification, object: nil)
    }
    
    func connectControllers(){
        
        //print("func connectControllers")
         for controller in GCController.controllers() {
            print("for controller")
    
            if (counter == 0){
                print(counter)
                controller.playerIndex = GCControllerPlayerIndex.IndexUnset
                print("Player Index in loop: " + "\(controller.playerIndex.hashValue)")
                counter++
            }
            
            print("Extended Gamepad: " + "\(controller.extendedGamepad)")
            print("Player Index: " + "\(controller.playerIndex)")
            
            
            
            if (controller.extendedGamepad != nil && controller.playerIndex == GCControllerPlayerIndex.IndexUnset){
                print("controller extended Gamepad")
                controller.playerIndex = .Index1
                
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedController(controller)
            }
            
            // Matt added
            setUpExtendedController(controller)
            
        }
        
    }
    
    func setUpExtendedController(controller: GCController){
        
        print("func setUpExtendedController")
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad:GCExtendedGamepad, element:GCControllerElement) in
            
            if (gamepad.buttonA == element){
                print("Button A")
            }
            
            
 //           if (gamepad.leftThumbstick == element){
//                print("gamepad")
//                if (gamepad.leftThumbstick.up.value > 0.2){
//                    print("Thumbstick Up")
//                } else if (gamepad.leftThumbstick.down.value > 0.2){
//                    print("Thumbstick Down")
//                } else if (gamepad.leftThumbstick.right.value > 0.2){
//                    print("Thumbstick Right")
//                } else if (gamepad.leftThumbstick.left.value > 0.2){
//                    print("Thumbstick Left")
//                }
//                
//            } else if (gamepad.dpad == element){
//                
//                if (gamepad.dpad.down.pressed == true){
//                    print("Dpad Down")
//                } else if (gamepad.dpad.up.pressed == true){
//                    print("Dpad Up")
//                } else if (gamepad.dpad.right.pressed == true){
//                    print("Dpad Right")
//                } else if (gamepad.dpad.left.pressed == true){
//                    print("Dpad Left")
//                }
//                
//            } else if (gamepad.buttonA == element){
//                print("Button A")
//            } else if (gamepad.buttonX == element){
//                print("Button X")
//            } else if (gamepad.leftShoulder == element){
//                print("Left Shoulder")
//            } else if (gamepad.leftTrigger == element){
//                print("Left Trigger")
//            } else if (gamepad.rightShoulder == element){
//                print("Right Shoulder")
//            } else if (gamepad.rightTrigger == element){
//                print("Right Trigger")
//            }
//            if (gamepad.controller?.playerIndex == .Index1){
//                thePlayerBeingController = thePlayer1
//            } else (gamepad.controller?.playerIndex == .Index2){
//                thePlayerBeingController = thePlayer2
//            }
//            thePlayerBeingController.moveRight
        }
        
    }
    
    func controllerDisconnected(){
        
    }
    
}
