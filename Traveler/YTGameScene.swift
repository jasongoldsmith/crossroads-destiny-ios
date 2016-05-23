//
//  YTGameScene.swift
//  Traveler
//
//  Created by Ashutosh on 5/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import SpriteKit


class YTGameScene: SKScene {

    let player = SKSpriteNode(imageNamed: "iconCloseSm")
    var enemy: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = (UIColor.blackColor())
        
        player.position = CGPoint(x: player.frame.size.width/2, y: player.frame.size.height)
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.3)
                ])
            ))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        self.enemy = SKSpriteNode(imageNamed: "iconError")
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: self.enemy!.size.width/2, max: size.width - self.enemy!.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        self.enemy!.position = CGPoint(x: actualX, y: size.height + self.enemy!.size.height/2)
        
        // Add the monster to the scene
        addChild(self.enemy!)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -self.enemy!.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        self.enemy!.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "iconArrowRight")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = CGPoint(x: 100, y: 100)
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = -direction.y * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position.x
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: 600,y: 600), duration: 0.3)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    deinit {
        
    }
}
