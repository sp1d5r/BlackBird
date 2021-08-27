//
//  Users.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation

struct User : Hashable {
    var username: String
    var fullname: String
    var bio: String
    var avatar: String
    var isCurrentUser: Bool = false
}

