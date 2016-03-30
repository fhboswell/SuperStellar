//
//  IntroScene.swift
//  SuperStellar
//
//  Created by Henry Boswell on 3/26/16.
//  Copyright © 2016 Henry Boswell. All rights reserved.
//


import SpriteKit

class IntroScene: SKScene {
    

    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    let instructionLabel: SKLabelNode = SKLabelNode(fontNamed: "BM germar")
    var introImage:SKSpriteNode?
    
    
    
    override func didMoveToView(view: SKView) {
        
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        print(screenHeight)
        print(screenWidth)
        self.backgroundColor = SKColor.blackColor()
        self.anchorPoint = CGPointMake(0.5, 0.0)
        
        
        //let introImage:SKSpriteNode(imageNamed: "intro_screen")
        let tex:SKTexture = SKTexture(imageNamed: "intro_screen_phone")
        let theSize = CGSizeMake(screenWidth * 1.2, screenHeight * 1.2)
        
        introImage = SKSpriteNode(texture: tex, size: theSize)
        self.addChild(introImage!)
        introImage!.position = CGPointMake(0, screenHeight / 1.72)
        createInstructionLabel()
        
    }
    
  
    
    func createInstructionLabel(){
        
        
        
        instructionLabel.horizontalAlignmentMode = .Center
        instructionLabel.verticalAlignmentMode = .Center
        instructionLabel.fontColor = UIColor.whiteColor()
        instructionLabel.text = "START"
        instructionLabel.zPosition = 1
        
        addChild(instructionLabel)
        instructionLabel.position = CGPointMake(0, screenHeight * 0.45)
        instructionLabel.fontSize = 60
        
        
        
        //SKActions
        let wait:SKAction = SKAction.waitForDuration(1)
        let fadeDown:SKAction = SKAction.fadeAlphaTo(0,duration: 0.2)
        let fadeUp:SKAction = SKAction.fadeAlphaTo(1,duration: 0.2)
        let seq:SKAction = SKAction.sequence([wait, fadeDown, fadeUp])
        let rep:SKAction = SKAction.repeatActionForever(seq)
        instructionLabel.runAction(rep)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        let transition = SKTransition.fadeWithDuration(1)
        let scene = GameScene(size: self.scene!.size)
        scene.testPassVar = 4
        scene.scaleMode = SKSceneScaleMode.AspectFill
        
        
        
        self.scene!.view!.presentScene(scene, transition: transition)
        
        
        /*
         let fadeDown:SKAction = SKAction.fadeAlphaTo(0,duration: 0.2)
         let remove:SKAction = SKAction.removeFromParent()
         let seq:SKAction = SKAction.sequence([fadeDown, remove])
         instructionLabel.runAction(seq)
         introImage?.runAction(seq)
         */
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
}
