//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Alex Drewno on 9/14/16.
//  Copyright (c) 2016 Alex Drewno. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate, StreamDelegate{
    
    var shooter: SKSpriteNode!
    var shooter2 : SKSpriteNode!
    var firstTouch: CGPoint! = nil
    var movementTimer : Timer! = nil
    var shootingTimer : Timer! = nil
    let newCam: SKCameraNode = SKCameraNode()
    var dx : CGFloat = 0.0
    var dy : CGFloat = 0.0
    var shootingdx : CGFloat = 0.0
    var shootingdy : CGFloat = 0.0
    var angle : CGFloat = 0.0
    var background = SKSpriteNode(imageNamed: "TDS:Ground.png")
    var wall = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall1 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall2 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall3 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall4 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall5 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall6 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wall7 = SKSpriteNode(imageNamed: "TDS:Wall.png")
    var wallCorner = SKSpriteNode(imageNamed: "TDS:WallCorner.png")
    var wallCorner1 = SKSpriteNode(imageNamed: "TDS:WallCorner.png")
    var wallCorner2 = SKSpriteNode(imageNamed: "TDS:WallCorner.png")
    var wallCorner3 = SKSpriteNode(imageNamed: "TDS:WallCorner.png")
    var box = SKSpriteNode(imageNamed: "WoodenBox2.png")
    var powerUp = SKSpriteNode(color: UIColor.red, size: CGSize(width: 2, height: 2))
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var outputStream : OutputStream!
    var singlePlayer : Bool = false
    var health : Int = 100
    var dead : Bool = false
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = -1
        background.yScale = 10
        background.xScale = 10
        
        shooter = SKSpriteNode(imageNamed: "player.png")
        backgroundColor = UIColor.black
        shooter.position = CGPoint(x: self.background.position.x, y: self.background.position.y)
        shooter.size = CGSize(width: 60, height: 60)
        shooter.zPosition = 2
        
        /*
        wallCorner.position = CGPoint(x: -165,y: 0)
        wallCorner.zPosition = 2
        wallCorner.yScale = 1.5
        wallCorner.xScale = 1.5
        
        wall.position = CGPoint(x: 0,y: 0)
        wall.zPosition = 1
        wall.yScale = 2
        wall.xScale = 4
        
        wall1.position = CGPoint(x: 400,y: 0)
        wall1.zPosition = 1
        wall1.yScale = 2
        wall1.xScale = 4
        
        wallCorner1.position = CGPoint(x: 565,y: 0)
        wallCorner1.zPosition = 2
        wallCorner1.yScale = 1.5
        wallCorner1.xScale = 1.5
        
        wallCorner2.position = CGPoint(x: -165,y: -600)
        wallCorner2.zPosition = 2
        wallCorner2.yScale = 1.5
        wallCorner2.xScale = 1.5
        
        wall2.position = CGPoint(x: 0,y: -600)
        wall2.zPosition = 1
        wall2.yScale = 2
        wall2.xScale = 4
        
        wall3.position = CGPoint(x: 400,y: -600)
        wall3.zPosition = 1
        wall3.yScale = 2
        wall3.xScale = 4
        
        wallCorner3.position = CGPoint(x: 565,y: -600)
        wallCorner3.zPosition = 2
        wallCorner3.yScale = 1.5
        wallCorner3.xScale = 1.5
        
        box.position = CGPoint(x: 10,y: 90)
        box.zPosition = 1
        box.yScale = 2
        box.xScale = 2
        
        powerUp.position = CGPoint(x: 40,y: 150)
        powerUp.zPosition = 1
        powerUp.yScale = 20
        powerUp.xScale = 20

        
        wall.name = "wallHit"
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall1.name = "wallHit"
        wall1.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall1.physicsBody?.affectedByGravity = false
        wall1.physicsBody?.isDynamic = false
        wall1.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall2.name = "wallHit"
        wall2.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall2.physicsBody?.affectedByGravity = false
        wall2.physicsBody?.isDynamic = false
        wall2.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall3.name = "wallHit"
        wall3.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall3.physicsBody?.affectedByGravity = false
        wall3.physicsBody?.isDynamic = false
        wall3.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall4.name = "wallHit"
        wall4.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall4.physicsBody?.affectedByGravity = false
        wall4.physicsBody?.isDynamic = false
        wall4.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall5.name = "wallHit"
        wall5.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall5.physicsBody?.affectedByGravity = false
        wall5.physicsBody?.isDynamic = false
        wall5.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall6.name = "wallHit"
        wall6.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall6.physicsBody?.affectedByGravity = false
        wall6.physicsBody?.isDynamic = false
        wall6.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wall7.name = "wallHit"
        wall7.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall7.physicsBody?.affectedByGravity = false
        wall7.physicsBody?.isDynamic = false
        wall7.physicsBody?.contactTestBitMask = (wall.physicsBody?.collisionBitMask)!
        
        wallCorner.name = "wallHit"
        wallCorner.physicsBody = SKPhysicsBody(rectangleOf: wallCorner.size)
        wallCorner.physicsBody?.affectedByGravity = false
        wallCorner.physicsBody?.isDynamic = false
        wallCorner.physicsBody?.contactTestBitMask = (wallCorner.physicsBody?.collisionBitMask)!
        
        wallCorner1.name = "wallHit"
        wallCorner1.physicsBody = SKPhysicsBody(rectangleOf: wallCorner.size)
        wallCorner1.physicsBody?.affectedByGravity = false
        wallCorner1.physicsBody?.isDynamic = false
        wallCorner1.physicsBody?.contactTestBitMask = (wallCorner.physicsBody?.collisionBitMask)!
        
        wallCorner2.name = "wallHit"
        wallCorner2.physicsBody = SKPhysicsBody(rectangleOf: wallCorner.size)
        wallCorner2.physicsBody?.affectedByGravity = false
        wallCorner2.physicsBody?.isDynamic = false
        wallCorner2.physicsBody?.contactTestBitMask = (wallCorner.physicsBody?.collisionBitMask)!
        
        wallCorner3.name = "wallHit"
        wallCorner3.physicsBody = SKPhysicsBody(rectangleOf: wallCorner.size)
        wallCorner3.physicsBody?.affectedByGravity = false
        wallCorner3.physicsBody?.isDynamic = false
        wallCorner3.physicsBody?.contactTestBitMask = (wallCorner.physicsBody?.collisionBitMask)!
        
        box.name = "moveableBoxHit"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.isDynamic = true
        box.physicsBody?.contactTestBitMask = (box.physicsBody?.collisionBitMask)!
        */
        
        powerUp.name = "powerUpHit"
        powerUp.physicsBody = SKPhysicsBody(rectangleOf: powerUp.size)
        powerUp.physicsBody?.affectedByGravity = false
        powerUp.physicsBody?.isDynamic = false
        powerUp.physicsBody?.contactTestBitMask = (powerUp.physicsBody?.collisionBitMask)!
        
        shooter.name = "playerHit1"
        shooter.physicsBody = SKPhysicsBody(texture: shooter.texture!, size: shooter.size)
        shooter.physicsBody?.affectedByGravity = false
        shooter.physicsBody?.contactTestBitMask = (shooter.physicsBody?.collisionBitMask)!
        
        if appDelegate.mpcManager.session.connectedPeers.count > 0
        {
            shooter2 = SKSpriteNode(imageNamed: "player.png")
            shooter2.name = "playerHit2"
            shooter2.physicsBody = SKPhysicsBody(texture: shooter2.texture!, size: shooter2.size)
            shooter2.physicsBody?.affectedByGravity = false
            shooter2.physicsBody?.contactTestBitMask = (shooter2.physicsBody?.collisionBitMask)!
            shooter2.position = shooter.position
            shooter2.size = shooter.size
            addChild(shooter2)
        }
        else
        {
            singlePlayer = true
        }
        
        

        
        self.camera = newCam
        
        setupCamera()
        addPlayerConstraints()
/*
        addChild(powerUp)
        addChild(box)
        addChild(wall4)
        addChild(wall5)
        addChild(wallCorner)
        addChild(wall)
        addChild(wall1)
        addChild(wallCorner1)
        addChild(wallCorner2)
        addChild(wall2)
        addChild(wall3)
        addChild(wallCorner3)
        addChild(wall6)
        addChild(wall7)
 */
        addChild(newCam)
        addChild(shooter)
        addChild(background)
        
        if appDelegate.mpcManager.session.connectedPeers.count > 0
        {
            do
            {
                try outputStream = appDelegate.mpcManager.session.startStream(withName: "position", toPeer: appDelegate.mpcManager.session.connectedPeers[0])
                outputStream.schedule(in: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
                outputStream.open()

            }
            catch
            {
                print("something happened to the position stream!")
            }
            
        }

    }
    
    
    
    func spawnBullet()
    {
        //send bullet data in here with trajectory (start and end pos)
        
        
        let bullet : SKSpriteNode! = SKSpriteNode(imageNamed: "Bullet.png")
        bullet.xScale = 0.3
        bullet.yScale = 0.4
        bullet.zPosition = 1
        let bulletRotation = shooter.zRotation - CGFloat(M_PI_2)
        bullet.zRotation = bulletRotation
        let angle = shooter.zRotation
        
        //through testing, cos and sin are reversed in terms of x and y
        let newdy = sin(angle)
        let newdx = cos(angle)
        
        
        bullet.position = CGPoint(x: shooter.position.x + CGFloat(newdx)*60, y: shooter.position.y + CGFloat(newdy)*60)
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.contactTestBitMask = (bullet.physicsBody?.contactTestBitMask)!
        let newVector = CGVector(dx: Double(newdx) * 800,dy: Double(newdy) * 800)
        
        let shoot = SKAction.move(by: newVector, duration: 2)
        
        let s = NSStringFromCGPoint(bullet.position) + "_" + NSStringFromCGVector(newVector) + "_" + (NSString(string: String(describing: bulletRotation)) as String)
        appDelegate.mpcManager.sendData(dataToSend: s)
        
        bullet.run(shoot, completion: {
            bullet.removeFromParent()
        })
        addChild(bullet)
    }
    
    func enemyBulletShot(bulletPosition : CGPoint, vector: CGVector, rotation: CGFloat)
    {
        let bullet : SKSpriteNode! = SKSpriteNode(imageNamed: "Bullet.png")
        bullet.xScale = 0.3
        bullet.yScale = 0.4
        bullet.zPosition = 1
        bullet.zRotation = rotation
        
        let angle = rotation
        
        //through testing, cos and sin are reversed in terms of x and y
        let newdy = sin(angle)
        let newdx = cos(angle)
        bullet.position = bulletPosition
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.contactTestBitMask = (bullet.physicsBody?.contactTestBitMask)!
        
        let shoot = SKAction.move(by: vector, duration: 2)
        
        bullet.run(shoot, completion: {
            bullet.removeFromParent()
        })
        addChild(bullet)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "bullet")
        {
            contact.bodyA.node?.removeAllActions()
            contact.bodyA.node?.removeFromParent()
            
            if contact.bodyB.node!.name == "playerHit1"
            {
                print(health)
                health -= 20
                checkIfDead()
            }
            
            print("hit: ", contact.bodyB.node?.name)
        } else if (contact.bodyB.node?.name == "bullet")
        {
            contact.bodyB.node?.removeAllActions()
            contact.bodyB.node?.removeFromParent()
            print("hit: ", contact.bodyA.node?.name)
            
            if contact.bodyA.node!.name == "playerHit1"
            {
                health -= 20
                print(health)
                checkIfDead()
            }
        }
        
        // powerUp Pick Up
        if (contact.bodyA.node?.name == "powerUpHit" && (contact.bodyB.node?.name == "playerHit" || contact.bodyB.node?.name == "player2Hit"))
        {
            contact.bodyA.node?.removeFromParent()
            //shooter.damagePlayer(100)
        } else if ((contact.bodyB.node?.name == "playerHit" || contact.bodyB.node?.name == "player2Hit") && contact.bodyB.node?.name == "powerUpHit")
        {
            contact.bodyB.node?.removeFromParent()
        }
    }
    func addPlayerConstraints()
    {
        
        let xRange = SKRange(lowerLimit: -background.frame.width/2.0, upperLimit: background.frame.width/2.0)
        let yRange = SKRange(lowerLimit: -background.frame.height/2.0, upperLimit: background.frame.height/2.0)
        let playerConstraint = SKConstraint.positionX(xRange, y: yRange)
        self.shooter.constraints = [playerConstraint]
        
    }
    
    func setupCamera()
    {
        
        let xRange = SKRange(lowerLimit: -background.frame.width/2.0+self.view!.frame.width/1.5, upperLimit: background.frame.width/2.0-self.view!.frame.width/1.5)
        let yRange = SKRange(lowerLimit: -background.frame.height/2.0+self.view!.frame.height/2.2, upperLimit: background.frame.height/2.0-self.view!.frame.height/1.5)
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        let distanceConstraint = SKConstraint.distance(SKRange(constantValue: 0), to: shooter)
        
        self.newCam.constraints = [distanceConstraint]
        self.newCam.constraints!.append(levelEdgeConstraint)
    }
    
    func startShooting()
    {
        shootingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.spawnBullet), userInfo: nil, repeats: true)
    }
    
    
    func startMovement()
    {
        movementTimer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(GameScene.movement), userInfo: nil, repeats: true)
    }
    
    func movement()
    {
        let angle = atan2(Float(dx), Float(dy))
        
        //through testing, cos and sin are reversed in terms of x and y
        let newdy = cos(angle)
        let newdx = sin(angle)
        
        if !dead
        {
            shooter.position.x += CGFloat(newdx) * 7
            shooter.position.y += CGFloat(newdy) * 7
        }
    }
    
    func checkIfDead()
    {
        if health == 0
        {
            shooter.removeFromParent()
            dead = true
            if appDelegate.mpcManager.session.connectedPeers.count > 0
            {
                appDelegate.mpcManager.sendData(dataToSend: "dead")
                delay(5, closure: { 
                    self.addChild(self.shooter)
                    self.health = 100
                    self.dead = false
                    self.shooter.position.x = CGFloat(GKRandomDistribution(lowestValue: Int(-self.background.frame.width/2 + 50), highestValue: 0).nextInt())
                    self.shooter.position.y = CGFloat(GKRandomDistribution(lowestValue: Int(-self.background.frame.height/2 + 50), highestValue: Int(self.background.frame.height/2)).nextInt())
                })
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if appDelegate.mpcManager.session.connectedPeers.count > 0
        {
            
            let s = NSStringFromCGPoint(shooter.position) + "_" + (NSString(string: String(describing: shooter.zRotation)) as String)
            let encodedDataArray = [UInt8](s.utf8)
            if outputStream.hasSpaceAvailable
           {
                outputStream.write(encodedDataArray, maxLength: encodedDataArray.count)
            }
        
            shooter2.position = appDelegate.mpcManager.position
            shooter2.zRotation = appDelegate.mpcManager.rotation
            
            if appDelegate.mpcManager.shotBullet
            {
                appDelegate.mpcManager.shotBullet = false
                
                enemyBulletShot(bulletPosition: appDelegate.mpcManager.bulletPosition, vector: appDelegate.mpcManager.vector, rotation: appDelegate.mpcManager.bulletRotation)
            }
            
            if appDelegate.mpcManager.dead
            {
                print("called2")
                appDelegate.mpcManager.dead = !appDelegate.mpcManager.dead
                shooter2.removeFromParent()
                shooter2.position = CGPoint(x: -10000, y: -10000)
                delay(5, closure: {
                    self.addChild(self.shooter2)
                })
            
                
            }
            
        }
    }
}
