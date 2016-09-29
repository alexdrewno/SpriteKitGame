import SpriteKit
import UIKit

class IntroScreenScene: SKScene {

    
    var tdsNode : SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        tdsNode = SKLabelNode(text: "TDS: Shooter")
        tdsNode.position = CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY)
        tdsNode.fontName = "futura"
        tdsNode.color = UIColor.white
        tdsNode.fontSize = 70
        
        
        addChild(tdsNode)
        
    }
    
}
