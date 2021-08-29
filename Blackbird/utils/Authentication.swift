//
//  Authentication.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 27/08/2021.
//

import Foundation
import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthenticationError : Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch  self {
            case .invalidCredentials:
                return NSLocalizedString("Password/Username is incorrect.", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have denied access. Go to settings app and locate the application turn FaceID on.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("You have not registered any Face ID's.", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
            case .biometricError:
                return NSLocalizedString("Unrecognised fingerprint or face ID.", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Credentials not saved.", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool){
        withAnimation {
            isValidated = success
        }
    }
    
    func theType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void){
        let credentials: Credentials? = KeyChainStorage.getCredentials()
        
        guard let credentials1 = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        
        let context = LAContext()
        var error: NSError?
        let canEval = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFingerprintEnrolled))
                } else {
                    completion(.failure(.biometricError))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        
        if canEval {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") {
                    success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials1))
                        }
                    }
                }
            }
        }
    }
}
