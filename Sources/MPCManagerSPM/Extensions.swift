//
//  Extensions.swift
//  ImageSharing
//
//  Created by Anshul Kumar on 16/03/26.
//

import Foundation

public extension String {
    var hoster: String {
        "_Hoster"
    }
    
    var receiver: String {
        "_Receiver"
    }
    
    func getMPCUsername() -> String {
        if self.contains(String().hoster) {
            return self.replacingOccurrences(of: String().hoster, with: "")
        } else {
            return self.replacingOccurrences(of: String().receiver, with: "")
        }
    }
    
    func getRole() -> UserRole {
        if self.contains(String().hoster) {
            return .sender
        } else {
            return .receiver
        }
    }
}
