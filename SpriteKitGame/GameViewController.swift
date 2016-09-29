//
//  GameViewController.swift
//  SpriteKitGame
//
//  Created by Alex Drewno on 9/14/16.
//  Copyright (c) 2016 Alex Drewno. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let rightCircle = UIView(frame: CGRect(origin: CGPoint(x: -1,y: -1), size: CGSize(width: 150, height: 150)))
    let rightSmallCircle = UIView(frame: CGRect(origin: CGPoint(x: -1,y: -1), size: CGSize(width: 40, height: 40)))
    let leftCircle = UIView(frame: CGRect(origin: CGPoint(x: 0.5,y: 0.5), size: CGSize(width: 150, height: 150)))
    let leftSmallCircle = UIView(frame: CGRect(origin: CGPoint(x: -1,y: -1), size: CGSize(width: 40, height: 40)))
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var scene : GameScene! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(fileNamed:"GameScene")!
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        
        rightCircle.clipsToBounds = true
        leftCircle.clipsToBounds = true
        
        rightCircle.layer.cornerRadius = 75
        leftCircle.layer.cornerRadius = 75
        
        rightCircle.layer.borderColor = UIColor.gray.cgColor
        leftCircle.layer.borderColor = UIColor.gray.cgColor
        
        leftCircle.layer.borderWidth = 4
        leftCircle.alpha = 0.3
        
        rightCircle.layer.borderWidth = 4
        rightCircle.alpha = 0.3
        
        rightSmallCircle.layer.backgroundColor = UIColor.gray.cgColor
        leftSmallCircle.layer.backgroundColor = UIColor.gray.cgColor
        
        rightSmallCircle.alpha = 0.3
        leftSmallCircle.alpha = 0.3
        
        rightSmallCircle.layer.cornerRadius = 20
        leftSmallCircle.layer.cornerRadius = 20
        
        self.view.isMultipleTouchEnabled = true
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouchLocation = touches.first?.location(in: self.view)
        
        if firstTouchLocation!.x < self.view.frame.width/3
        {
            if !self.leftCircle.isDescendant(of: self.view)
            {

                leftSmallCircle.frame.origin = firstTouchLocation!
                leftSmallCircle.frame.origin.x -= 20
                leftSmallCircle.frame.origin.y -= 20
                self.view.addSubview(leftSmallCircle)
                
                leftCircle.frame.origin = firstTouchLocation!
                leftCircle.frame.origin.x -= 75
                leftCircle.frame.origin.y -= 75
                self.view.addSubview(leftCircle)
                
                if scene.movementTimer == nil
                {
                    scene.startMovement()
                }
            }
        }
        else if firstTouchLocation!.x > self.view.frame.width/1.5
        {
            if !self.rightCircle.isDescendant(of: self.view)
            {
                
                rightSmallCircle.frame.origin = firstTouchLocation!
                rightSmallCircle.frame.origin.x -= 20
                rightSmallCircle.frame.origin.y -= 20
                self.view.addSubview(rightSmallCircle)
                
                rightCircle.frame.origin = firstTouchLocation!
                rightCircle.frame.origin.x -= 75
                rightCircle.frame.origin.y -= 75
                self.view.addSubview(rightCircle)
                
                if scene.shootingTimer == nil
                {
                    scene.startShooting()
                }
                
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            if touch.location(in: self.view).x > self.view.frame.width/2 && touch.previousLocation(in: self.view).x > self.view.frame.width/2
            {
                let distance = sqrt(pow(touch.location(in: self.view).x-rightCircle.frame.origin.x-75, 2) + pow(touch.location(in: self.view).y-rightCircle.frame.origin.y-75,2))
                if distance > 75
                {
                    let dx = touch.location(in: self.view).x - rightCircle.frame.origin.x - 55
                    let dy = touch.location(in: self.view).y - rightCircle.frame.origin.y - 55
                    
                    let angle = atan2f(Float(dx), Float(dy))
                    var newdx = sin(angle)
                    var newdy = cos(angle)
                    
                    if newdx < 0
                    {
                        newdx = -1 * sqrt(abs(newdx)) * 75
                    }
                    else
                    {
                        newdx = sqrt(newdx) * 75
                    }
                    
                    if newdy < 0
                    {
                        newdy = -1 * sqrt(abs(newdy)) * 75
                    }
                    else
                    {
                        newdy = sqrt(newdy) * 75
                    }
                    
                    let newPosition = CGPoint(x: CGFloat(newdx) + rightCircle.frame.origin.x + 55, y: CGFloat(newdy) + rightCircle.frame.origin.y + 55)
                   rightSmallCircle.frame.origin = newPosition
                    
                    let dx2 = rightSmallCircle.frame.origin.x - rightCircle.frame.origin.x - 55
                    let dy2 = rightSmallCircle.frame.origin.y - rightCircle.frame.origin.y - 55
                    
                    var angle2 = atan2f(Float(dy2), Float(dx2))
                    angle2 *= -1.0
                    let action = SKAction.rotate(toAngle: CGFloat(angle2), duration: 0.001)
                    scene.shooter.run(action)
                    
                    
                    //updates while the bullet shoots
                    scene.shootingdx = dx
                    scene.shootingdy = -dy
                    
                }
                else
                {
                    rightSmallCircle.frame.origin = touch.location(in: self.view)
                    rightSmallCircle.frame.origin.x -= 20
                    rightSmallCircle.frame.origin.y -= 20
                    
                    let dx = rightSmallCircle.frame.origin.x - rightCircle.frame.origin.x - 55
                    let dy = rightSmallCircle.frame.origin.y - rightCircle.frame.origin.y - 55
                    
                    var angle = atan2f(Float(dy), Float(dx))
                    angle *= -1.0
                    let action = SKAction.rotate(toAngle: CGFloat(angle), duration: 0.001)
                    scene.shooter.run(action)
                    
                    
                    //updates while the bullet shoots
                    scene.shootingdx = dx
                    scene.shootingdy = -dy
                }

            }

            else
            {
               let distance = sqrt(pow(touch.location(in: self.view).x-leftCircle.frame.origin.x-75, 2) + pow(touch.location(in: self.view).y-leftCircle.frame.origin.y-75,2))
                if distance > 75
                {
                    let dx = touch.location(in: self.view).x - leftCircle.frame.origin.x - 55
                    let dy = touch.location(in: self.view).y - leftCircle.frame.origin.y - 55
                    
                    let angle = atan2f(Float(dx), Float(dy))
                    var newdx = sin(angle)
                    var newdy = cos(angle)
                    
                    if newdx < 0
                    {
                        newdx = -1 * sqrt(abs(newdx)) * 75
                    }
                    else
                    {
                        newdx = sqrt(newdx) * 75
                    }
                    
                    if newdy < 0
                    {
                        newdy = -1 * sqrt(abs(newdy)) * 75
                    }
                    else
                    {
                        newdy = sqrt(newdy) * 75
                    }
                    
                    let newPosition = CGPoint(x: CGFloat(newdx) + leftCircle.frame.origin.x + 55, y: CGFloat(newdy) + leftCircle.frame.origin.y + 55)
                    leftSmallCircle.frame.origin = newPosition

                    let dx2 = leftSmallCircle.frame.origin.x - leftCircle.frame.origin.x-55
                    let dy2 = leftSmallCircle.frame.origin.y - leftCircle.frame.origin.y-55
                    
                    scene.dx = dx2
                    scene.dy = -dy2

                    
                }
                else
                {
                    leftSmallCircle.frame.origin = touch.location(in: self.view)
                    leftSmallCircle.frame.origin.x -= 20
                    leftSmallCircle.frame.origin.y -= 20
                    
                    let dx = leftSmallCircle.frame.origin.x - leftCircle.frame.origin.x-55
                    let dy = leftSmallCircle.frame.origin.y - leftCircle.frame.origin.y-55
                    
                    scene.dx = dx
                    scene.dy = -dy
                    
                }
            }
       }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let endingTouchLocation = touches.first!.location(in: self.view)
        
        
        if endingTouchLocation.x < self.view.frame.width/2
        {
            if self.leftCircle.isDescendant(of: self.view)
            {
                leftCircle.removeFromSuperview()
                leftCircle.frame.origin = CGPoint(x: -100,y: -100)
                leftSmallCircle.removeFromSuperview()
                leftSmallCircle.frame.origin = CGPoint(x: -100,y: -100)
                if scene.movementTimer != nil
                {
                    scene.movementTimer.invalidate()
                    scene.movementTimer = nil
                }
                
            }

        }
        else if endingTouchLocation.x > self.view.frame.width/2
        {
            if self.rightCircle.isDescendant(of: self.view)
            {
                rightCircle.removeFromSuperview()
                rightCircle.frame.origin = CGPoint(x: -100,y: -100)
                rightSmallCircle.removeFromSuperview()
                rightSmallCircle.frame.origin = CGPoint(x: -100,y: -100)
            }
            
            if scene.shootingTimer != nil
            {
                scene.shootingTimer.invalidate()
                scene.shootingTimer = nil
            }
        }
        
    }
    
    

    override var shouldAutorotate : Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
