//
//  GameScene.swift
//  SuperStellar
//
//  Created by Henry Boswell on 3/28/16.
//  Copyright (c) 2016 Henry Boswell. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation


enum BodyType:UInt32 {
    
    case player = 1
    case bullet = 2
    case badGuyLesser = 4
    
}


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    var testPassVar:Int?
    
    var lives:Int = 0
    
    var gameIsActive = false
    
    var additionValueForX:Float = 0.0
    var additionValueForY:Float = 0.0
    let speedBoaster:Float = 10.0
    var yOffset:Float = 0.0
    
    
    let motionManager:CMMotionManager = CMMotionManager()
    
    
    
    let loopingBG:SKSpriteNode = SKSpriteNode(imageNamed: "stars")
    let loopingBG2:SKSpriteNode = SKSpriteNode(imageNamed: "stars")
    
    let player:SKSpriteNode = SKSpriteNode(imageNamed: "player")
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    let instructionLabel: SKLabelNode = SKLabelNode(fontNamed: "BM germar")
    
    //let tapRecognizer = UITapGestureRecognizer()
    
    

    
    var leftGun:Bool = false
    
    
    override func didMoveToView(view: SKView) {
        
        print(testPassVar)
        
        //get the height
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        
        
        //0,0 is on the bottom in the middle
        self.anchorPoint = CGPointMake(0.5, 0.0)
        
        //no gravity in space
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        //if things contact we will hear about it in a method below
        physicsWorld.contactDelegate = self
        
        
        /*
        //get taps and run selector
        tapRecognizer.addTarget(self, action:#selector(GameScene.viewWasTappedMethod))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRecognizer)
       */
        
        setUpBackground()
        
        setUpMovement()
        
        addPlayer()
        
        startGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //on touch down begin firing and repeat forever
        let wait:SKAction = SKAction.waitForDuration(0.2)
        let fire:SKAction = SKAction.performSelector(#selector(GameScene.createBullet), onTarget: self)
        let seq:SKAction = SKAction.sequence([fire, wait ])
        let rep:SKAction = SKAction.repeatActionForever(seq)
        self.runAction(rep, withKey:"fireAction")
    }
    
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //on touch up end firing
        super.touchesEnded(touches, withEvent: event)
        self.removeActionForKey("fireAction")
        print("here")
    }
 
    
    
    
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    //Mark: Gesture Selectors
    
    func viewWasTappedMethod(){
        //createBullet()
        
        
    }
    
    //Mark:Shoot
    func createBullet(){
        
        //give the bullet the correct properties
        let bullet:SKSpriteNode = SKSpriteNode(imageNamed: "laserGreen")
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 3)
        bullet.physicsBody!.categoryBitMask = BodyType.bullet.rawValue
        bullet.zRotation = 0
        bullet.name = "bullet"
        
        
        //alternate guns
        if(leftGun == true )
        {
            bullet.position = CGPointMake(player.position.x - player.size.width /   2.2, player.position.y + 30)
            leftGun = false
        } else{
            bullet.position = CGPointMake(player.position.x + player.size.width / 2.2 , player.position.y + 30)
            leftGun = true
        }
        
        addChild(bullet)
       
        //make the bullet go
        let theForce:CGVector = CGVectorMake(0, 60)
        bullet.physicsBody?.applyForce(theForce)
        
        
        createFiringParticles(bullet.position)
        
    }
    
    func createFiringParticles(location: CGPoint){
        
        //create particles
        let fireEmitter = SKEmitterNode(fileNamed: "FireParticles")
        var loc = location
        loc.y = loc.y - 30
        fireEmitter!.position = loc
        fireEmitter!.numParticlesToEmit = 10
        fireEmitter?.zPosition = 1
        fireEmitter?.targetNode = self
        fireEmitter!.yAcceleration = 2000
        
        
        self.addChild(fireEmitter!)
        
    }
    
    
    //MARK: Movement
    
    func setUpMovement(){
        if (motionManager.accelerometerAvailable == true) {
            
            //not highly tested
            motionManager.accelerometerUpdateInterval = 1/40
            
            
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                
                // Moves object on the X
                
                self.additionValueForX = Float(data!.acceleration.x) * self.speedBoaster
                
                let farX = self.screenWidth / 2
                
                if ( self.player.position.x + CGFloat(self.additionValueForX) < farX  && self.player.position.x + CGFloat(self.additionValueForX) > -(farX) ) {
                    
                    //displays the correct banking immage
                    if(self.additionValueForX > 1){
                        self.player.texture = SKTexture(imageNamed: "playerRight")
                    }else if(self.additionValueForX < -1){
                        self.player.texture = SKTexture(imageNamed: "playerLeft")
                    }else{
                        self.player.texture = SKTexture(imageNamed: "player")
                    }
                    self.player.position = CGPointMake(self.player.position.x + CGFloat( self.additionValueForX ), self.player.position.y)
                    
                }
                
                
            })
        }
    }
    
    
    //MARK: Background
    
    
    func setUpBackground(){
        
        self.backgroundColor = SKColor.blackColor()
       //add nodes with background image
        addChild(loopingBG)
        addChild(loopingBG2)
        
        
        //position background in the back
        loopingBG.zPosition = -100
        loopingBG2.zPosition = -100
        
        
        //stack the immages on on top of the other so they can go by with no gap
        loopingBG.position = CGPointMake(0, 0)
        loopingBG.position = CGPointMake(0, loopingBG.size.height)
        
        
       
        startLoopingBackground()
        
                
        
        
        

        
        
    }
    
    func startLoopingBackground(){
        
        //conveyer-belt-action
        let move:SKAction = SKAction.moveByX(0, y: -loopingBG.size.height, duration: 80)
        let moveBack:SKAction = SKAction.moveByX(0, y: loopingBG.size.height, duration: 0)
        let seq:SKAction = SKAction.sequence([move, moveBack])
        let rep:SKAction = SKAction.repeatActionForever(seq)
        loopingBG.runAction(rep)
        loopingBG2.runAction(rep)
        
        
    }
    
    // MARK: player
    
    func addPlayer(){
        
        //add and position the player
        addChild(player)
        player.zPosition = 100
        player.position = CGPointMake(0, 100)
        
        //give player physics details
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.categoryBitMask = BodyType.player.rawValue
        player.physicsBody!.dynamic = false
        
        
    }
    
    
    // MARK: game
    func startGame(){
        gameIsActive = true
        lives = 2
        print("in startGame")
        
        
        //start missiles
        
        initiateEnemy()
        
        //check to see if the game is over
        startGameOverTesting()
        
        
        //clear out unseen objects
        clearOutOfSceneItems()
    }

    
    func startGameOverTesting(){
        
        //test if the game is over every 2 seconds
        let wait:SKAction = SKAction.waitForDuration(1)
        let block:SKAction = SKAction.runBlock(gameOverTest)
        let seq:SKAction = SKAction.sequence([wait, block])
        let rep:SKAction = SKAction.repeatActionForever(seq)
        self.runAction(rep,withKey:"gameOverTest")
        
        
    }
    
    
    func gameOverTest(){
        
        if (lives <=  0)
        {
            self.gameOver()
        }
        
    }
    
    func gameOver(){
        print("gameOver")
        
        motionManager.stopAccelerometerUpdates()
       
        self.removeActionForKey("enemyLaunchAction")
        
        let wait:SKAction = SKAction.waitForDuration(3)
        let block:SKAction = SKAction.runBlock(transition)
        let seq:SKAction = SKAction.sequence([wait, block])
        self.runAction(seq)
        
    }
    
    func transition(){
            
        let transition = SKTransition.fadeWithDuration(1)
        let scene = IntroScene(size: self.scene!.size)
            
        scene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(scene, transition: transition)
        
        
    }
    
    func clearOutOfSceneItems(){
        
        clearBullets()
        
        
        //repeat this method every 2 seconds
        let wait:SKAction = SKAction.waitForDuration(2)
        let block:SKAction = SKAction.runBlock(clearOutOfSceneItems)
        let seq:SKAction = SKAction.sequence([wait, block])
        self.runAction(seq,withKey:"clearAction")
        print("clearing")
        
    }
    
    
    
    func clearBullets(){
        
        //go through all  the bullets and get rid of them if they are not visible
        self.enumerateChildNodesWithName("bullet"){
            node, stop in
            if(node.position.x < -((self.screenWidth / 2) - 50)) {
                
                node.removeFromParent()
            }else if(node.position.x > ((self.screenWidth / 2) + 50)) {
                
                node.removeFromParent()
            } else if(node.position.y > self.screenHeight + 100) {
                
                node.removeFromParent()
                print("removed bullet")
            }
        }
        
    }
    
    //MARK: enemy
    
    func initiateEnemy(){
        
        //launch an enemy every two seconds
        let wait:SKAction = SKAction.waitForDuration(2)
        let block:SKAction = SKAction.runBlock(launchEnemyLesser)
        let seq:SKAction = SKAction.sequence([block, wait])
        let rep:SKAction = SKAction.repeatActionForever(seq)
        self.runAction(rep,withKey:"enemyLaunchAction")
        
        
        
    }
    
    func launchEnemyLesser(){
        
        
        //make a bad guy
        let enemyLesser:BadGuyLesser = BadGuyLesser()
        enemyLesser.createBadGuyLesser("enemyShip")
        addChild(enemyLesser)
        
        
        //decide where to drop him and then do it
        let randomX = arc4random_uniform(UInt32(screenWidth))
        enemyLesser.position = CGPointMake(CGFloat(randomX) - (screenWidth / 2), screenHeight + 100 )
        enemyLesser.physicsBody?.applyImpulse(CGVector(dx:0, dy:-50))
    }


    
    //MARK: interaction
    func createExplosion(atLocation: CGPoint, image:String){
        //what image will we be morphing and where
        let explosion:SKSpriteNode = SKSpriteNode(imageNamed: image)
        explosion.position = atLocation
        self.addChild(explosion)
        explosion.zPosition = 300
        
        //start small and expand
        explosion.xScale = 0.1
        explosion.yScale = explosion.xScale
        let grow:SKAction = SKAction.scaleTo(1, duration: 0.5)
        grow.timingMode = .EaseOut
        //fade to white while doing this
        let color:SKAction = SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 0.5, duration: 0.5)
        let group:SKAction = SKAction.group( [grow, color])
        
        //then the opposite 
        let fade:SKAction = SKAction.fadeAlphaTo(0, duration: 1)
        fade.timingMode = .EaseIn
        let shrink:SKAction = SKAction.scaleTo(0.8, duration: 1)
        let group2:SKAction = SKAction.group([fade, shrink])
        
        let remove:SKAction = SKAction.removeFromParent()
        let seq:SKAction = SKAction.sequence([group, group2, remove])
        explosion.runAction(seq)
    }


    func didBeginContact(contact: SKPhysicsContact) {
        if( contact.bodyA.categoryBitMask == BodyType.badGuyLesser.rawValue && contact.bodyB.categoryBitMask == BodyType.bullet.rawValue){
            if let enemy = contact.bodyA.node! as? BadGuyLesser{
                lesserEnemyAndbullet(enemy)
            }
            
            contact.bodyB.node!.name = "removeNode"
            
            
        } else if( contact.bodyB.categoryBitMask == BodyType.badGuyLesser.rawValue && contact.bodyA.categoryBitMask == BodyType.bullet.rawValue){
            if let enemy = contact.bodyB.node! as? BadGuyLesser{
                lesserEnemyAndbullet(enemy)
            }
            
            contact.bodyA.node!.name = "removeNode"
            
            
        } else if( contact.bodyA.categoryBitMask == BodyType.badGuyLesser.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let enemy = contact.bodyA.node! as? BadGuyLesser{
                playerHit(enemy)
            }
            
            contact.bodyA.node!.name = "removeNode"
            
            
            
            
        } else if( contact.bodyB.categoryBitMask == BodyType.badGuyLesser.rawValue && contact.bodyA.categoryBitMask == BodyType.player.rawValue){
            
            if let enemy = contact.bodyA.node! as? BadGuyLesser{
                playerHit(enemy)
            }
            
            contact.bodyB.node!.name = "removeNode"
            
            
            
        }

    }
    
    override func didSimulatePhysics() {
        
        // clean up
        self.enumerateChildNodesWithName("removeNode"){
            node, stop in
            node.removeFromParent()
        }
    }
    
    
    //generalize and overload?
    func lesserEnemyAndbullet(theEnemy:BadGuyLesser){
        
        
        let thePoint:CGPoint = theEnemy.position
        
        //run hit and get result
        if (theEnemy.hit()){
            createExplosion(thePoint, image: "explosion")
            
        } else {
            //not dead yet but hit was run
        }
    }
    
    func playerHit(theEnemy:BadGuyLesser){
        self.lives =  self.lives - 1
        let thePoint:CGPoint = theEnemy.position
        createExplosion(thePoint, image: "explosion2")
        
    }

    
    
    
}
