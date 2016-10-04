import SpriteKit
import UIKit

protocol introDelegate {
    func startedGame()
}

class IntroScreenScene: SKScene {

    
    var tdsNode : SKLabelNode!
    var startNode : SKLabelNode!
    var iDelegate : introDelegate?
    var backgroundNode : SKSpriteNode!
    
    // scene set up
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        tdsNode = SKLabelNode(text: "TDS: Shooter")
        tdsNode.position = CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY+50)
        tdsNode.fontName = "futura"
        tdsNode.color = UIColor.white
        tdsNode.fontSize = 70
        tdsNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.83, duration: 3), SKAction.scale(to: 1.2, duration: 3)])))
        
        startNode = SKLabelNode(text: "Play")
        startNode.position = CGPoint(x: tdsNode.position.x, y: tdsNode.position.y - 80)
        startNode.fontName = "futura"
        startNode.color = UIColor.white
        startNode.fontSize = 30
        
        backgroundNode = SKSpriteNode(imageNamed: "TDS-MenuBackground")
        backgroundNode.position = CGPoint(x: startNode.position.x, y: startNode.position.y)
        backgroundNode.size = CGSize(width: frame.width, height: frame.height)
        backgroundNode.zPosition = -1
        
        addChild(tdsNode)
        addChild(startNode)
        addChild(backgroundNode)
    }
    
    // allows fo rhte start button to be pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            if startNode.contains(location)
            {
                iDelegate?.startedGame()
            }
        }
    
    }
}
