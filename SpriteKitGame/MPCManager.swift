

import UIKit
import MultipeerConnectivity
import GameKit

// delegate allowing for setup of the connections between devices
protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
}

// this class is for the set up of the conectivity for players to conect to each other
class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, StreamDelegate {
    
    var delegate: MPCManagerDelegate?
    
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler: ((Bool, MCSession)->Void)!
    
    var position: CGPoint! = CGPoint(x: 0, y: 0)
    
    var rotation: CGFloat! = 0.0
    
    var shotBullet : Bool = false
    var spawn : Int = 0
    var vector : CGVector! = CGVector(dx:0,dy:0)
    var bulletPosition : CGPoint = CGPoint(x:0,y:0)
    var bulletRotation : CGFloat = 0
    
    var dead = false
    
    // set up data for other players to see
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "tdshooter")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "tdshooter")
        advertiser.delegate = self
    }
    
    
    // MARK: MCNearbyServiceBrowserDelegate method implementation
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer()
    }
    
    
    
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
        delegate?.lostPeer()
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    
    
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation

    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    
    
    // MARK: MCSessionDelegate method implementation
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            delegate?.connectedWithPeer(peerID: peerID)
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    private func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        certificateHandler(true)
    }
    
    // holds the data for the current sesion that is being played such as the bullet and position and rotations
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
        let data = dictionary["data"]
        let text = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue)!
        if text.contains("_")
        {
            let messageArray = String(describing:text).characters.split(separator: "_").map(String.init)
            if messageArray.count == 3
            {
                bulletPosition = CGPointFromString(String(messageArray[0]))
                vector = CGVectorFromString(String(messageArray[1]))
                bulletRotation = CGFloat((messageArray[2] as NSString).doubleValue)

                shotBullet = true
            }
            
        }
        else
        {
            print("called")
            dead = true
        }
        
    }
    
    // functions that do nothing but need to be in as to make the compiler not crash
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Assuming a stream of UInt8's
        var buffer = [UInt8](repeating: 0, count: 8)
        
        stream.open()
        stream.schedule(in: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        stream.delegate = self
        print("Are we working")
        // Read a single byte
        if stream.hasBytesAvailable {
            let result: Int = stream.read(&buffer, maxLength: buffer.count)
            print("result: \(result)")
        }
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch(eventCode){
        case Stream.Event.hasBytesAvailable:
            let input = aStream as! InputStream
            var buffer = [UInt8](repeating: 0, count: 1024) //allocate a buffer. The size of the buffer will depended on the size of the data you are sending.
            let numberBytes = input.read(&buffer, maxLength:1024)
            let dataString = NSMutableData(bytes: &buffer, length: numberBytes)
            //print(dataString.length)
            let message = NSString(data: dataString as Data, encoding: String.Encoding.utf8.rawValue)!
            let messageArray = String(describing:message).characters.split(separator: "_").map(String.init)
            if messageArray.count == 2
            {
                let point = CGPointFromString(messageArray[messageArray.count-2])
                let zRotation = CGFloat((messageArray[messageArray.count-1] as NSString).doubleValue)
                rotation = zRotation
                position = point
            }

        //input
        case Stream.Event.hasSpaceAvailable:
            break
        //output
        default:
            break
        }
    }
    
    // sends data to the other device via the sesion
    func sendData(dataToSend: String)
    {
         //print("sending... : " + dataToSend)
        
        if session.connectedPeers.count > 0
        {
            do
            {
                try session.send(dataToSend.data(using: .utf8)!, toPeers: session.connectedPeers, with: MCSessionSendDataMode.unreliable)
               //print("sent")
            }
            catch
            {
                print("error sending")
            }
            
        }
    }
}


