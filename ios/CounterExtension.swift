//
//  CounterExtension.swift
//  mpc1
//
//  Created by Bijay Jena on 15/12/22.
//

import MultipeerConnectivity

extension Counter: MCSessionDelegate {
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      switch state {
        case .notConnected:
            print("Not Connected!")
        case .connecting:
            print("Connecting to \(peerID.displayName).")
        case .connected:
            print("Connected to \(peerID.displayName).")
//            sendEvent(withName: "connection_state", body: ["Connection Successful"])
          // MARK: - Send Data
          do {
            let dataVal = "Connected Bhai!".data(using: .utf8)
            try mcSession.send(dataVal!, toPeers: mcSession.connectedPeers, with: .reliable)
          } catch let error {
              print(error.localizedDescription)
          }
        @unknown default:
            fatalError("No State Matched!")
      }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    
    print(String(data: data, encoding: .utf8) ?? "No Data Recieved")
    sendEvent(withName: "msgRcv", body: [String(data: data, encoding: .utf8)])
    
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
}

extension Counter: MCNearbyServiceBrowserDelegate {
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    mcNearbyServiceBrowser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 5)
    mcNearbyServiceBrowser.startBrowsingForPeers()
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    
  }
  
}

extension Counter: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
      invitationHandler(true, mcSession)
  }
  
}
