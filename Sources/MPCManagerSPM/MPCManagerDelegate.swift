//
//  MPCManagerDelegate.swift
//  ImageSharing
//
//  Created by Anshul Kumar on 16/03/26.
//

import Foundation
import MultipeerConnectivity

public protocol MPCManagerDelegate: AnyObject {
    func didReceiveData(_ data: Data, from peerID: MCPeerID)
    func didChangeUserList(_ userList: [any MPCResource])
    func onReceiveError(_ error: Error)
}
