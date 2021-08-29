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


struct RecordType {
    static let Users = "People"
    static let Conversation = "Conversation"
    static let Message = "Message"
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

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL!) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}

func tryLogin(username: String, password: String, completion: @escaping (Result<ExampleUser, Error>) -> ()){
    let pred = NSPredicate(format: "username==%@ AND password==%@", argumentArray: [username, password])
    let query = CKQuery(recordType: RecordType.Users, predicate: pred)
    let operations = CKQueryOperation(query: query)
    operations.resultsLimit = 1
    
    operations.recordFetchedBlock = { record in
        DispatchQueue.main.async {
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
    
    operations.queryCompletionBlock = { (_, err) in
        DispatchQueue.main.async {
            if let err = err {
                completion(.failure(err))
                return
            }
        }
    }
    
    CKContainer.default().publicCloudDatabase.add(operations)
    
}

func getUserDetails(username: String, completion: @escaping (Result<ExampleUser, Error>) -> ()) {
    let pred = NSPredicate(format: "username==%@", argumentArray: [username])
    let query = CKQuery(recordType: RecordType.Users, predicate: pred)
    let operations = CKQueryOperation(query: query)
    operations.resultsLimit = 1
    
    operations.recordFetchedBlock = { record in
        DispatchQueue.main.async {
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
    
    operations.queryCompletionBlock = { (_, err) in
        DispatchQueue.main.async {
            if let err = err {
                completion(.failure(err))
                return
            }
        }
    }
    
    CKContainer.default().publicCloudDatabase.add(operations)
}

func getConversations(username: String, completion: @escaping (Result<Conversation, Error>) -> ()) {
    let pred = NSPredicate(format: "users contains %@", username)
    let query = CKQuery(recordType: RecordType.Conversation, predicate: pred)
    let operations = CKQueryOperation(query: query)
    operations.resultsLimit = 50
    
    
    operations.recordFetchedBlock = { record in
        DispatchQueue.main.async {
            let id = record.recordID
            guard let users = record["users"] as? [String] else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            let element = Conversation(recordID: id, users: users)
            completion(.success(element))
        }
    }
    
    operations.queryCompletionBlock = { (_, err) in
        DispatchQueue.main.async {
            if let err = err {
                completion(.failure(err))
                return
            }
        }
    }
    
    CKContainer.default().publicCloudDatabase.add(operations)
}

func getMessages(convoID: String, completion: @escaping (Result<Message, Error>) -> ()) {
    print("gettting conversation:", convoID)
    let pred = NSPredicate(format: "conversationID == %@", convoID )
    let query = CKQuery(recordType: RecordType.Message, predicate: pred)
    let operations = CKQueryOperation(query: query)
    operations.resultsLimit = 100
    
    operations.recordFetchedBlock = { record in
        DispatchQueue.main.async {
            let id = record.recordID
            guard let sender = record["sender"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let recipient = record["recipient"] as? [String] else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let conversationID = record["conversationID"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let messageType = record["messageType"] as? Int else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            guard let body = record["body"] as? String else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            print("finds element:", body)
            let element = Message(recordID: id, sender: sender, recipient: recipient, conversationID: conversationID, messageType: messageType, body: body)
            completion(.success(element))
        }
    }
    
    operations.queryCompletionBlock = { (_, err) in
        DispatchQueue.main.async {
            if let err = err {
                completion(.failure(err))
                return
            }
        }
    }
    
    CKContainer.default().publicCloudDatabase.add(operations)
}


func sendMessage(sender: String, recipient: String, body: String, conversationID: String, messageType: Int, completion: @escaping (Result<Message, Error>)-> ()){
    let messageRecord = CKRecord(recordType: RecordType.Message)
    messageRecord["sender"] = sender as CKRecordValue
    messageRecord["recipient"] = [recipient] as CKRecordValue
    messageRecord["conversationID"] = conversationID as CKRecordValue
    messageRecord["messageType"] = messageType as CKRecordValue
    messageRecord["body"] = body as CKRecordValue
    
    let publicContainer = CKContainer.default().publicCloudDatabase
    
    publicContainer.save(messageRecord) { (record, error) in
        if let error = error {
            completion(.failure(error))
        }
        guard let record = record else {
            completion(.failure(CloudKitHelperError.recordFailure))
            return
        }
        let id = record.recordID
        guard let sender = record["sender"] as? String else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        guard let recipient = record["recipient"] as? [String] else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        guard let conversationID = record["conversationID"] as? String else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        guard let messageType = record["messageType"] as? Int else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        guard let body = record["body"] as? String else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        let element = Message(recordID: id, sender: sender, recipient: recipient, conversationID: conversationID, messageType: messageType, body: body)
        completion(.success(element))
    }
    
}

func createConversation(user1: String, user2: String, completion: @escaping (Result<Conversation, Error>) -> ()){
    let conversationRecord = CKRecord(recordType: RecordType.Conversation)
    conversationRecord["users"] = [user1, user2] as CKRecordValue
    
    let publicContainer = CKContainer.default().publicCloudDatabase
    
    publicContainer.save(conversationRecord) { (record, error) in
        if let error = error {
            completion(.failure(error))
        }
        guard let record = record else {
            completion(.failure(CloudKitHelperError.recordFailure))
            return
        }
        let id = record.recordID
        guard let record_users = record["users"] as? [String] else {
            completion(.failure(CloudKitHelperError.castFailure))
            return
        }
        let element = Conversation(recordID: id, users: record_users)
        completion(.success(element))
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
