import SpriteKit
import UIKit

protocol introDelegate {
    func startedGame()
}

class IntroScreenScene: SKScene {

    
    var tdsNode : SKLabelNode!
    var startNode : SKLabelNode!
    var iDelegate : introDelegate?
    
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
        
        
        addChild(tdsNode)
        addChild(startNode)
        
    }
    
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
