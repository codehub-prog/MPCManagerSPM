//
//  MPCManager.swift
//  ImageSharing
//
//  Created by Anshul Kumar on 28/02/26.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

@MainActor
public final class MPCManager: NSObject {
    
    public let shared = MPCManager()
    
    private var serviceType: String!
    private var myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    private var currentUser: (any MPCResource)!
    private var connectedUsers: [any MPCResource] = []
    
    public weak var delegate: MPCManagerDelegate?
    
    private override init() {
        super.init()
    }
    
    private func startSession() {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
    }
}

public extension MPCManager {
    
    func configService(serviceType: String = "anshul-demo", currentUser: any MPCResource, delegate: MPCManagerDelegate? = nil) {
        self.currentUser = currentUser
        self.serviceType = serviceType
        self.delegate = delegate
        myPeerID = MCPeerID(displayName: currentUser.peerIdentifiableName)
        startSession()
        if currentUser.userRole == .receiver {
            browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
            browser.delegate = self
        } else {
            advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
            advertiser.delegate = self
        }
    }
    
    func startPeering() {
        switch currentUser.userRole {
        case .receiver:
            if browser == nil { return }
            browser.startBrowsingForPeers()
        case .sender:
            if advertiser == nil { return }
            advertiser.startAdvertisingPeer()
        }
    }
    
    func resetSession() {
        switch currentUser.userRole {
        case .receiver:
            browser.stopBrowsingForPeers()
        case .sender:
            advertiser.stopAdvertisingPeer()
        }
        browser = nil
        advertiser = nil
    }
    
    func restartPeering() {
        resetSession()
        configService(currentUser: currentUser)
        startPeering()
    }
    
    func stopAllServices() {
        resetSession()
        session.connectedPeers.forEach { session.cancelConnectPeer($0) }
        session.disconnect()
        session = nil
    }
    
    func currentUser(formPeer peer: MCPeerID) -> (any MPCResource)? {
        if let user = connectedUsers.first(where: {$0.peerID == peer }) {
            return user
        }
        return nil
    }
    
    func sendData(data: Data, peerId: MCPeerID) {
        guard session.connectedPeers.contains(peerId) else {
            return
        }
        do {
            try session.send(data, toPeers: [peerId], with: .reliable)
        } catch {
            self.delegate?.onReceiveError(error)
        }
    }
}

extension MPCManager: @MainActor MCSessionDelegate {
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    
    public func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if state == .notConnected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.startPeering()
                }
            } else if
                let hostPeerName = session.connectedPeers.first(where: {$0.displayName.contains(String().hoster)}),
                state == .connected,
                let mediaData = self.currentUser.media {
                self.sendData(data: mediaData, peerId: hostPeerName)
            }
        }
    }
    
    public func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        guard let localURL = localURL else { return }
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(resourceName)
        
        try? FileManager.default.moveItem(at: localURL, to: destinationURL)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            do {
                let data = try Data(contentsOf: destinationURL)
                if peerID.displayName.contains(String().receiver)  {
                    self.manageUsers(data: data, peerID: peerID)
                }  else {
                    self.delegate?.didReceiveData(data, from: peerID)
                }
            } catch {
                self.delegate?.onReceiveError(error)
            }
        }
    }
    
    public func session(_: MCSession, didReceive: Data, fromPeer: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if fromPeer.displayName.contains(String().receiver)  {
                self.manageUsers(data: didReceive, peerID: fromPeer)
            }  else {
                self.delegate?.didReceiveData(didReceive, from: fromPeer)
            }
        }
    }
    
    func manageUsers(data: Data, peerID: MCPeerID) {
        
        if connectedUsers.isEmpty {
            connectedUsers = [getUser(data: data, peerID: peerID)]
        } else {
            if !connectedUsers.contains(where: {$0.peerID == peerID}) {
                connectedUsers.append(getUser(data: data, peerID: peerID))
            }
        }
        delegate?.didChangeUserList(connectedUsers)
    }
    
    private func getUser(data: Data, peerID: MCPeerID) -> UserResource {
        let peerUserName = peerID.displayName
        return UserResource(userRole: peerUserName.getRole(), name: peerUserName.getMPCUsername(), media: data, peerID: peerID)
    }
}


extension MPCManager: @MainActor MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, session)
    }
}

extension MPCManager: @MainActor MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
}
