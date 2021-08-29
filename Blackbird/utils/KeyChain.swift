//
//  KeyChain.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 27/08/2021.
//

import Foundation
import SwiftKeychainWrapper

enum KeyChainStorage {
    static let key = "credentials"
    
    static func getCredentials() -> Credentials? {
        if let myCredsString = KeychainWrapper.standard.string(forKey: self.key){
            return Credentials.decode(myCredsString)
        } else {
            return nil
        }
    }
    
    static func saveCredentials(_ credentials: Credentials) -> Bool {
        if KeychainWrapper.standard.set(credentials.encoded(), forKey: self.key){
            return true
        } else {
            return false 
        }
    }
}
