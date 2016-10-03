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
import AVFoundation

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
    var box = SKSpriteNode(imageNamed: "WoodenBox2.png")
    var building = SKSpriteNode(imageNamed: "building.png")
    var building2 = SKSpriteNode(imageNamed: "building.png")
    var powerUp = SKSpriteNode(color: UIColor.red, size: CGSize(width: 2, height: 2))
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var outputStream : OutputStream!
    var singlePlayer : Bool = false
    var health : Int = 100
    var dead : Bool = false
    var healthLabelNode : SKLabelNode!
    var flashRedNode : SKSpriteNode!
    var shootSound = AVAudioPlayer()
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)

        flashRedNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 10000, height: 10000))
        flashRedNode.alpha = 0.1
        
        healthLabelNode = SKLabelNode(text: "Health: \(health)")
        healthLabelNode.position = CGPoint(x: (self.view?.frame.width)!/2 + 40, y: (self.view?.frame.height)!/2 + 40)
        healthLabelNode.fontName = "futura"
        healthLabelNode.zPosition = 10
        healthLabelNode.fontSize = 30
        healthLabelNode.fontColor = UIColor.red
    
        
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = -1
        background.yScale = 10
        background.xScale = 10
        
        shooter = SKSpriteNode(imageNamed: "player.png")
        backgroundColor = UIColor.black
        shooter.position = CGPoint(x: self.background.position.x, y: self.background.position.y)
        shooter.size = CGSize(width: 60, height: 60)
        shooter.zPosition = 2
        
        
        building.xScale = 1.1
        building.yScale = 1.1
        building.position = CGPoint(x:  CGFloat(-self.scene!.frame.width/2) - building.frame.width/4 , y: CGFloat(-self.scene!.frame.height/2) - building.frame.height/4)
        building.zRotation = CGFloat(-M_PI_2)
        building.physicsBody = SKPhysicsBody(bodies: [SKPhysicsBody(texture: building.texture!, size: building.size)])
        building.physicsBody!.affectedByGravity = false
        building.physicsBody!.isDynamic = false
        building.physicsBody!.contactTestBitMask = building.physicsBody!.collisionBitMask
        
        building2.xScale = 1.1
        building2.yScale = 1.1
        building2.position = CGPoint(x:  CGFloat(self.scene!.frame.width/2) + building2.frame.width/4, y: CGFloat(self.scene!.frame.height/2) + building2.frame.height/4)
        building2.zRotation = CGFloat(M_PI_2)
        building2.physicsBody = SKPhysicsBody(bodies: [SKPhysicsBody(texture: building.texture!, size: building.size)])
        building2.physicsBody!.affectedByGravity = false
        building2.physicsBody!.isDynamic = false
        building2.physicsBody!.contactTestBitMask = building.physicsBody!.collisionBitMask
        
        box.position = CGPoint(x: 10,y: 90)
        box.zPosition = 1
        box.yScale = 2
        box.xScale = 2
        
        box.name = "moveableBoxHit"
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.isDynamic = true
        box.physicsBody?.contactTestBitMask = (box.physicsBody?.collisionBitMask)!
        
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
            //shooter2.position = shooter.position
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
        
        addChild(box)
        addChild(building2)
        addChild(building)

        addChild(newCam)
        addChild(shooter)
        addChild(background)
        camera!.addChild(healthLabelNode)
        
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
        else
        {
            singlePlayer = true
        }

    }

    
    func spawnBullet()
    {
        
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
        
        // assign sound and play it
        shootSound = self.setupAudioPlayerWithFile("shot", type:"wav")
        shootSound.play()
    }
    
    func enemyBulletShot(bulletPosition : CGPoint, vector: CGVector, rotation: CGFloat)
    {
        let bullet : SKSpriteNode! = SKSpriteNode(imageNamed: "Bullet.png")
        bullet.xScale = 0.3
        bullet.yScale = 0.4
        bullet.zPosition = 1
        bullet.zRotation = rotation
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
                health -= 20
                hitDetected()
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
                hitDetected()
                checkIfDead()
            }
        }
        
        // powerUp Pick Up
        if (contact.bodyA.node?.name == "powerUpHit" && (contact.bodyB.node?.name == "playerHit" || contact.bodyB.node?.name == "player2Hit"))
        {
            contact.bodyA.node?.removeFromParent()
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
        healthLabelNode.text = "Health: \(health)"
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
                    if self.appDelegate.mpcManager.position.x > 0
                    {
                        self.shooter.position = self.building.position
                    }
                    else
                    {
                        self.shooter.position = self.building2.position
                    }
                })
            }
        }
    }
    
    func hitDetected()
    {
        camera!.addChild(flashRedNode)
        let flashAction = SKAction.sequence([SKAction.fadeAlpha(to: 0.3, duration: 0.4), SKAction.fadeAlpha(to: 0, duration: 0.4)])
        flashRedNode.run(flashAction) { 
            self.flashRedNode.removeFromParent()
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
                appDelegate.mpcManager.dead = !appDelegate.mpcManager.dead
                shooter2.removeFromParent()
                delay(5, closure: {
                    self.addChild(self.shooter2)
                })
            
                
            }
            
        }
    }
    
    // Sound setup
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        let path = Bundle.main.path(forResource: file as String, ofType:type as String)
        let url = URL(fileURLWithPath: path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player not available")
        }
        
        //4
        return audioPlayer!
    }
}
