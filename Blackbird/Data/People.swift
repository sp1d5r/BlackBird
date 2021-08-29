//
//  People.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 28/08/2021.
//

import Foundation
import CloudKit
import SwiftUI

/* Users */
struct ExampleUser : Identifiable, Equatable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var username: String
    var full_name: String
    var password: String
    var bio: String
    var email: String
    var avatar: UIImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: ExampleUser, rhs: ExampleUser) -> Bool {
        return lhs.username == rhs.username && lhs.full_name == rhs.full_name
    }
}
