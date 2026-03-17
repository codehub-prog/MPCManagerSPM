//
//  MPCResource.swift
//  ImageSharing
//
//  Created by Anshul Kumar on 16/03/26.
//

import UIKit
import MultipeerConnectivity

public protocol MPCResource: Identifiable, Equatable {
    var id: UUID { get set }
    var userRole: UserRole { get set }
    var name: String { get set }
    var media: Data? { get set }
    var isProfileImage: Bool { get set }
    var peerID: MCPeerID? { get set }
    var peerIdentifiableName: String { get }
}

public struct UserResource: MPCResource {
    public var id: UUID = UUID()
    public var userRole: UserRole
    public var name: String
    public var isProfileImage: Bool = false
    public var media: Data?
    public var peerID: MCPeerID? = nil
    
    public var peerIdentifiableName: String {
        name + ((userRole == .sender) ? String().hoster : String().receiver)
    }
}

public enum UserRole: String {
    case sender
    case receiver
}
extension UserRole: Equatable {}
extension UserRole: Hashable {}
extension UserRole: RawRepresentable {}
