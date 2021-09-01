//
//  ConversationListItem.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 29/08/2021.
//

import Foundation
import SwiftUI

class ObservableConversationItems : ObservableObject {
    @Published var otherUser : ExampleUser = ExampleUser(username: "", full_name: "", password: "", bio: "", email: "", avatar: UIImage())
    @Published var recentMessage : Message = Message(sender: "", recipient: [], conversationID: "", messageType: 1, body: "")
}

struct ConversationListItem: View {
    @StateObject var observableConversationItems = ObservableConversationItems()
    
    @State var myUsername : String
    @State var conversation : Conversation
    @Binding var messages : Bool
    @Binding var currentConversation: String
    @Binding var currentConvoUser : ExampleUser
    @Binding var changed : Bool
    
    let pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("performReload"))
    
    init(myUsername: String, conversation: Conversation, messages: Binding<Bool>, currentConversation: Binding<String>, currentConvoUser: Binding<ExampleUser>, changed: Binding<Bool>) {
        self._myUsername = State(initialValue: myUsername)
        self._messages = messages
        self._conversation = State(initialValue: conversation)
        self._currentConversation = currentConversation
        self._currentConvoUser = currentConvoUser
        self._changed = changed
    }
    
    func goToUser(messages: inout Bool) {
        currentConversation = conversation.recordID?.recordName ?? ""
        currentConvoUser = observableConversationItems.otherUser
        messages = true
    }
    
    func getUserInfo(){
        /*myUsername: String, conversation: Conversation*/
        let otherUsername = (myUsername == conversation.users[0]) ? conversation.users[1] : conversation.users[0]
        Blackbird.getUserDetails(username: otherUsername){(result) in
            switch result {
            case .success(let otherUser1):
                observableConversationItems.otherUser = otherUser1
            case .failure(let error):
                print("Failed to get user details", error)
            }
        }
    }
    
    func getRecent(){
        /* conversation: Conversation*/
        let tempConvo = conversation.recordID?.recordName ?? ""
        getRecentMessage(convoID: tempConvo ){(result) in
            switch result {
            case .success(let message):
                observableConversationItems.recentMessage = message
            case .failure(let error):
                print("Failed to get recent message", error)
            }
        }
    }
    
    
    var body : some View {
        Button(action : {goToUser(messages: &messages)}) {
            HStack{
                Image(uiImage: observableConversationItems.otherUser.avatar)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(25)
                VStack{
                    HStack{
                        Text(observableConversationItems.otherUser.full_name).fontWeight(.medium).foregroundColor(.white)
                        /*
                         TO Add -- Recent Messages and if they've been seen or not.
                         
                         if (!recentMessage.seen) {
                         Circle().frame(maxWidth: 5, maxHeight: 5).foregroundColor(.red)
                            } else {
                         if (recentMessage.sender == myUsername) {
                             Circle().frame(maxWidth: 5, maxHeight: 5).foregroundColor(.white)
                            }
                         ) */
                        if (observableConversationItems.recentMessage.sender == myUsername) {
                            Circle().frame(maxWidth: 5, maxHeight: 5).foregroundColor(.white)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                    Text(observableConversationItems.recentMessage.body).fontWeight(.thin).foregroundColor(.white).frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading).padding(.horizontal, 5)
                }.frame(maxWidth: UIScreen.screenWidth*3/4, alignment: .topLeading)
            }
        }.listRowBackground(Color(red: 3/255, green: 15/255, blue: 17/255))
        .onAppear(perform: {
            getUserInfo()
            getRecent()
            setNotifications(convoID: conversation.recordID?.recordName ?? "")
        })
        .onReceive(pub, perform: { _ in
            DispatchQueue.main.async {
                getUserInfo()
                getRecent()
                changed = !changed
            }
        })
        
    }
}
