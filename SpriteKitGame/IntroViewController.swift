import UIKit
import SpriteKit

class IntroViewController: UIViewController {
    
    var scene : IntroScreenScene! = nil

    override func viewDidLoad() {
        
        scene = IntroScreenScene(fileNamed:"IntroScreenScene")!
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)

    }
    
}
