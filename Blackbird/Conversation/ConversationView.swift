//
//  ConversationView.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI
import CloudKit

func groupArray(messages: [Message], currentUserName: String) -> [[Message]]{
    var finalArray : [[Message]] = []
    var tmp : [Message] = []
    var isCurrent = messages[0].sender
    
    for message in messages {
        
        if (message.sender ==  isCurrent) {
            // Same as the user before
            tmp.append(message)
        } else {
            finalArray.append(tmp)
            tmp = [message]
        }
        isCurrent = message.sender
    }
    if tmp != [] {
        finalArray.append(tmp)
    }
    return finalArray
}

class ObservableMessages : ObservableObject{
    // the published means whenever you change it it reupdates
    @Published var allMessages: [Message] = []
    @Published var groupedMessages : [[Message]] = []
}

struct ConversationView : View {
    
    
    @State var typingMessage: String = ""
    @StateObject var observerableMessages = ObservableMessages()
    
    @Binding var messages : Bool
    @Binding var conversationID : String
    @Binding var currentUser : ExampleUser
    @Binding var otherUser: ExampleUser
    let pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("performReload"))
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init(messages: Binding<Bool>, conversationID: Binding<String>, currentUser: Binding<ExampleUser>, otherUser: Binding<ExampleUser>) {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        // Get all the messages from the conversation.
        self._conversationID = conversationID
        self._messages = messages
        self._currentUser = currentUser
        self._otherUser = otherUser
        
        UIScrollView.appearance().backgroundColor = UIColor(Color(red: 3/255, green: 15/255, blue: 17/255))
        
    }

    func initMessages(){
        print("Here with convoid", conversationID)
        getMessages(convoID: conversationID){(record) in
            switch record{
            case .success(let message):
                if (!observerableMessages.allMessages.contains(message)){
                    observerableMessages.allMessages.append(message)
                    observerableMessages.groupedMessages = groupArray(messages: observerableMessages.allMessages, currentUserName: currentUser.username)
                }
                // UPDATE THE LIST WHEN NEW MESSAGES GET ADDED
                
            case .failure(let error):
                print("Failed to get a message")
                print(error)
            }
        }
    }
    
    var body: some View {
            NavigationView {
                VStack(spacing: 0) {
                    CustomScrollView(scrollToEnd: true) {
                        ForEach(observerableMessages.groupedMessages, id: \.self) { msg in
                            MessageView(currentMessage: msg, avatar: otherUser.avatar, myUsername: currentUser.username).background(Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea())
                        }
                    }.frame(maxHeight: .infinity).background(Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea())
                    
                    
                    
                    /*ScrollView(.vertical) {
                        VStack(spacing: 10) {
                        
                        
                    }.listStyle(PlainListStyle()).frame(maxWidth: .infinity, maxHeight: .infinity)
                    }*/
                    HStack {
                        TextField("Message...", text: $typingMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: CGFloat(30))
                        Button(action: sendTypedMessage, label: {
                            Text("Send")
                        })
                    }.frame(maxWidth: .infinity, minHeight: CGFloat(50)).padding()
                }.navigationBarItems(leading: Button(action: {returnFromUser(messages: &messages)}) { Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)}).navigationBarTitle(otherUser.full_name)
                .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom).offset(y: -keyboard.currentHeight*0.005)
            }.onAppear(perform: {initMessages()}).onReceive(pub, perform: { _ in
                DispatchQueue.main.async {
                    initMessages()
                }
            })
    }
    
    func sendTypedMessage() {
        sendMessage(sender: currentUser.username, recipient: otherUser.username, body: typingMessage, conversationID: conversationID, messageType: 1) {(result) in
            switch result {
            case .success(let message):
                print("Successfully added messsage!")
                DispatchQueue.main.async {
                    observerableMessages.allMessages.append(message)
                    observerableMessages.groupedMessages = groupArray(messages: observerableMessages.allMessages, currentUserName: currentUser.username)
                }
            case .failure(let error):
                print("Failed to send message")
                print(error)
            }
        }
        // DataSource.messages.append(Message(content: typingMessage, user: DataSource.messages[1].user))
        // groupedMessages = groupArray(messages: DataSource.messages)
            typingMessage = ""
        }
     
    
}

