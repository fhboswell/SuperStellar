//
//  BadGuyLesser.swift
//  SuperStellar
//
//  Created by Henry Boswell on 3/28/16.
//  Copyright © 2016 Henry Boswell. All rights reserved.
//

import Foundation
import SpriteKit


class BadGuyLesser: SKNode {
    
    
    var BGLesserNode:SKSpriteNode = SKSpriteNode()
    var BGLesserAnimation: SKAction?
    
    let fireEmitter = SKEmitterNode(fileNamed: "FireParticles")
    
    
    var hitsToKill:Int = 2
    var hitCount:Int = 0
    var damagePoints:Int = 1
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not yet been implimented")
    }
    
    
    override init(){
        super.init()
    }
    
    
    
    func createBadGuyLesser(theImage:String){
        
        
        BGLesserNode = SKSpriteNode(imageNamed: theImage)
        self.addChild(BGLesserNode)
        let body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: BGLesserNode.size, center: CGPointMake(0, 0))
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = false
        body.friction = 0
       
        body.categoryBitMask = BodyType.badGuyLesser.rawValue
        body.contactTestBitMask = BodyType.player.rawValue | BodyType.bullet.rawValue
        self.physicsBody = body
        self.name = "BGL"
        
        
    }
    
    
    
    func hit() -> Bool {
        hitCount++
        if( hitCount == hitsToKill)
        {
            self.removeFromParent()
            return true
        } else {
            damagePoints = 1
            
            return false
        }
    }
    
    func destroy() {
        //self.removeFromParent()
        self.name = "removeNode"
    }
    
    
    
}
