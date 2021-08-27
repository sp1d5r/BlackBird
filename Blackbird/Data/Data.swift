//
//  Data.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI
import Combine

struct Data1 {
    var messages : [Message]
}

var DataSource : Data1 = Data1(messages: [Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: false)), Message(content: "You fucking liar i am elijah", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: false)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Message(content: "You fucking liar i am elijah", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: false)), Message(content: "Hi, I am your friend", user: User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true))])


class ChatHelper : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    @Published var realTimeMessages = DataSource.messages
    
    func sendMessage(_ chatMessage: Message) {
        realTimeMessages.append(chatMessage)
        didChange.send(())
    }
}

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
