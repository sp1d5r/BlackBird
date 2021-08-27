//
//  CloudKitManager.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import CloudKit
import SwiftUI
 
enum FetchError {
    case fetchingError, noRecords, none
}


struct ExampleUser : Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var username: String
    var full_name: String
    var password: String
    var bio: String
    var email: String
    var avatar: UIImage
}

struct RecordType {
    static let Users = "People"
}

enum CloudKitHelperError: Error {
    case recordFailure
    case recordIDFailure
    case castFailure
    case cursorFilure
}
 
extension UIImage {
    func toCKAsset(name: String? = nil) -> CKAsset? {
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }

        guard let imageFilePath = NSURL(fileURLWithPath: documentDirectory)
                .appendingPathComponent(name ?? "asset#\(UUID.init().uuidString)")
        else {
            return nil
        }

        do {
            try self.pngData()?.write(to: imageFilePath)
            return CKAsset(fileURL: imageFilePath)
        } catch {
            print("Error converting UIImage to CKAsset!")
        }

        return nil
    }
}

struct CloudKitManager {
    
    private let RecordType = "Users"
    
    /*func fetchTasks(completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: "{YOUR_CONTAINER_IDENTIFIER}").publicCloudDatabase
        let query = CKQuery(recordType: RecordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
            self.processQueryResponseWith(records: records, error: error as NSError?, completion: { fetchedRecords, fetchError in
                completion(fetchedRecords, fetchError)
            })
        })
    }*/
    
    
    private func processQueryResponseWith(records: [CKRecord]?, error: NSError?, completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        guard error == nil else {
            completion(nil, .fetchingError)
            return
        }
        
        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }
        
        completion(records, .none)
    }
}

func saveUser(user: User, completion: @escaping (Result<User, Error>) -> () ) {
    
}

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL!) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}

func updateUser(user: ExampleUser, completion: @escaping (Result<ExampleUser, Error>) -> ()){
    let userRecord = CKRecord(recordType: RecordType.Users)
    userRecord["username"] = user.username as CKRecordValue
    userRecord["password"] = user.password as CKRecordValue
    userRecord["full_name"] = user.full_name as CKRecordValue
    userRecord["bio"] = user.bio as CKRecordValue
    userRecord["email"] = user.email as CKRecordValue
    
    let publicContainer = CKContainer.default().publicCloudDatabase
    
    if let asset = user.avatar.toCKAsset() {
        userRecord.setObject(asset, forKey: "avatar")

        publicContainer.save(userRecord) { (record, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let record = record else {
                completion(.failure(CloudKitHelperError.recordFailure))
                return
            }
            let id = record.recordID
            guard let username = record["username"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let full_name = record["full_name"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let password = record["password"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let bio = record["bio"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let email = record["email"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let avatar = record["avatar"] as? CKAsset else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let avatarImage = avatar.toUIImage() else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            let element = ExampleUser(recordID: id, username: username, full_name: full_name, password: password, bio: bio, email: email, avatar: avatarImage)
            completion(.success(element))
        }
    }
    
    
    
}
