//
//  Conversation.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 28/08/2021.
//

import Foundation
import CloudKit

/* Conversations */
struct Conversation : Identifiable, Equatable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var users: [String]
}
