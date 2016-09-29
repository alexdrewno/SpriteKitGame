import UIKit
import MultipeerConnectivity

class HomeViewController: UIViewController,  MPCManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func foundPeer()
    {
        print("foundPeer")
        appDelegate.mpcManager.browser.invitePeer(appDelegate.mpcManager.foundPeers[0], to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
    }
    
    func lostPeer()
    {
        print("lostPeer")
    }
    
    func invitationWasReceived(fromPeer: String)
    {
        print("invitationWasReceived")
       //appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to play TDShooter.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
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
    
    func connectedWithPeer(peerID: MCPeerID)
    {
        print("connectedWithPeer")
        OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "gameSegue", sender: self)
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
