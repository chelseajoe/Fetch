//
//  ChatRoom.swift
//  fetch
//
//  Created by Anh Vu on 4/10/23.
//

import Foundation
import ParseSwift

struct ChatRoom: ParseObject {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Chat room properties
    var messages: [ChatMessage]?
    var users: [String]?
    var lastUpdated: Date?
}

struct ChatMessage: ParseObject {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Chat message properties
    var user: String?
    var message: String?
}


