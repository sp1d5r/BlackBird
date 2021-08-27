//
//  ConversationView.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

func groupArray(messages: [Message]) -> [[Message]]{
    var finalArray : [[Message]] = []
    var tmp : [Message] = []
    var isCurrent = messages[0].user.isCurrentUser
    
    for message in messages {
        
        if message.user.isCurrentUser == isCurrent {
            // Same as the user before
            tmp.append(message)
        } else {
            finalArray.append(tmp)
            tmp = [message]
        }
        isCurrent = message.user.isCurrentUser
    }
    if tmp != [] {
        finalArray.append(tmp)
    }
    return finalArray
}


struct ConversationView : View {
    
    @State var typingMessage: String = ""
    @State var chatHelper : Data1 = DataSource
    @State var groupedMessages : [[Message]] = groupArray(messages: DataSource.messages)
    @Binding var messages : Bool
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init(messages: Binding<Bool>) {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        self._messages = messages
    }

    var body: some View {
            NavigationView {
                VStack(spacing: 0) {
                    List {
                        ForEach(groupedMessages, id: \.self) { msg in
                            MessageView(currentMessage: msg)
                        }
                    }.listStyle(PlainListStyle()).frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack {
                        TextField("Message...", text: $typingMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: CGFloat(30))
                        Button(action: {sendMessage()}) {
                            Text("Send")
                        }
                    }.frame(maxWidth: .infinity, minHeight: CGFloat(50)).padding()
                }.navigationBarItems(leading: Button(action: {returnFromUser(messages: &messages)}) { Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)}).navigationBarTitle(Text(DataSource.messages[0].user.fullname), displayMode: .inline)
                .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
            }
        }
    
    func sendMessage() {
        DataSource.messages.append(Message(content: typingMessage, user: DataSource.messages[1].user))
        groupedMessages = groupArray(messages: DataSource.messages)
            typingMessage = ""
        }

    
}
