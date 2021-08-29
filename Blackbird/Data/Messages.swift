//
//  Messages.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 28/08/2021.
//

import Foundation
import CloudKit

/* Message */
struct Message : Identifiable, Equatable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var sender: String
    var recipient: [String]
    var conversationID: String
    var messageType: Int
    var body: String
}

/*
 Message Type:
  1. Normal Message - body of the text only
  2. Image Message - just an image.
  3. Location ? - This will be the current location
  4. Bash Commands ???? - Sends bash commands to my server?   <-- this could be so cold
 */
