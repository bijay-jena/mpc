//
//  Counter.swift
//  mpc1
//
//  Created by Bijay Jena on 14/12/22.
//

import Foundation
import MultipeerConnectivity

@objc(Counter)
class Counter: RCTEventEmitter {
  
  override init() {
    super.init()
    
    peerID = MCPeerID(displayName: UIDevice.current.name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = self
  }
  
  private var count = 0;
  
  var adv: Bool = false
  
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
  var mcNearbyServiceBrowser: MCNearbyServiceBrowser!
  
  var rcvdMsg: String = "No messages Yet"
  
  @objc
  func setUpDevice(_ name: String) {
    peerID = MCPeerID(displayName: name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = self
  }
  
  @objc
  func host() {
      if adv {
          print("Stopped Hosting.")
          adv = false
          
          mcNearbyServiceAdvertiser.stopAdvertisingPeer()
      } else {
          print("Started Hosting.")
          adv = true
          
          mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "wifi1")
          mcNearbyServiceAdvertiser.delegate = self
          mcNearbyServiceAdvertiser.startAdvertisingPeer()
      }
  }
  
  @objc
  func join() {
      print("Clicked Join")
      
      mcNearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "wifi1")
      mcNearbyServiceBrowser.delegate = self
      mcNearbyServiceBrowser.startBrowsingForPeers()
  }
  
  @objc
  func sendMsg(_ msg: String) {
    do {
      let dataVal = msg.data(using: .utf8)
      try mcSession.send(dataVal!, toPeers: mcSession.connectedPeers, with: .reliable)
    } catch let error {
        print(error.localizedDescription)
    }
  }
  
  @objc
  func increment(_ callback:RCTResponseSenderBlock) {
    count += 1;
//    print(count);
    callback([count])
  }
  
  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  @objc
  override func constantsToExport() -> [AnyHashable: Any]! {
    return ["initialCount": 0]
  }
  
  override func supportedEvents() -> [String]! {
    return ["msgRcv"]
  }
  
  @objc
  func decrement(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    if (count == 0) {
      let err = NSError(domain: "", code: 200);
      reject("ERROR_COUNT","count cannot be negative", err);
    } else {
      count -= 1
      resolve("Count is \(count)")
    }
  }
  
}
