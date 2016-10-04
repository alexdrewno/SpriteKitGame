import UIKit
import MultipeerConnectivity

class HomeViewController: UIViewController,  MPCManagerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bullets: [UIImageView]!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var multiplayerView: UIView!
    @IBOutlet weak var singleplayerView: UIView!
    
    // set up the object locations on the view
    override func viewDidLoad() {
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        tableView.delegate = self
        tableView.dataSource = self
        for bullet in bullets
        {
            bullet.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        }
        
        player.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        
        multiplayerView.layer.borderWidth = 5
        singleplayerView.layer.borderWidth = 5
        multiplayerView.layer.borderColor = UIColor.darkGray.cgColor
        singleplayerView.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    // both reload the data in the table view
    func foundPeer()
    {
        print("foundPeer")
        tableView.reloadData()
        
    }
    
    func lostPeer()
    {
        print("lostPeer")
        tableView.reloadData()
    }
    
    // if the device can connect to another device create a pop up and allow player to join
    func invitationWasReceived(fromPeer: String)
    {
        print("invitationWasReceived")
       //appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to play TDShooter.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
            self.appDelegate.mpcManager.spawn = 2
        }
        let decline = UIAlertAction(title: "Decline", style: .default) { (alertAction) in
            print("decline")
        }
        
            
        alert.addAction(acceptAction)
        alert.addAction(decline)
            
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // called if invitation was accepted and take player to game view
    func connectedWithPeer(peerID: MCPeerID)
    {
        print("connectedWithPeer")
        OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "gameSegue", sender: self)
        }

    }
    
    // table view set up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.mpcManager.browser.invitePeer(appDelegate.mpcManager.foundPeers[indexPath.row], to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.mpcManager.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peercell")!
        cell.textLabel!.text! = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
        return cell
    }
    
    
    
}
