//
//  WebCredentialsHelper.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 29/08/2021.
//

import Foundation

enum SharedWebCredentialsManagerError: Error {
    case noCredentialsFound
    case generatePasswordFailed
    case saveFailed(String)
    case deleteFailed(String)
}

enum SharedWebCredentialsManager {
    static let domain: String = "blackbird.herokuapp.com"

    static func save(account: String, password: String, completion: ((Bool, SharedWebCredentialsManagerError?) -> Void)? = nil) {
        SecAddSharedWebCredential(SharedWebCredentialsManager.domain as CFString, account as CFString, password as CFString?) { error in
            guard let error = error else {
                completion?(true, nil)
                return
            }
            let errorDescription = CFErrorCopyDescription(error) as String
            let saveFailedError = SharedWebCredentialsManagerError.saveFailed(errorDescription)
            completion?(false, saveFailedError)
        }
    }


}
