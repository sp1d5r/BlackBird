//
//  Message.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

struct MessageView : View {
    var currentMessage: [Message]
    var body: some View {
        VStack {
                ForEach(0..<currentMessage.count-1) { ind in
                    HStack(alignment: .bottom, spacing: 15){
                        if currentMessage[ind].user.isCurrentUser {
                            Spacer()
                        }
                            ContentMessageView(contentMessage: currentMessage[ind].content,
                                       isCurrentUser: currentMessage[ind].user.isCurrentUser)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 15) {
                    if !currentMessage[currentMessage.count - 1].user.isCurrentUser {
                        Image(currentMessage[currentMessage.count - 1].user.avatar)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(20)
                    } else {
                        Spacer()
                    }
                    ContentMessageView(contentMessage: currentMessage[currentMessage.count - 1].content,
                                   isCurrentUser: currentMessage[currentMessage.count-1].user.isCurrentUser)
                }
            
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: [Blackbird.Message(content: "You fucking liar i am elijah", user: Blackbird.User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true)), Blackbird.Message(content: "Hi, I am your friend", user: Blackbird.User(username: "elijah", fullname: "Elijah Ahmad", bio: "Hello! Welcome", avatar: "my-avatar", isCurrentUser: true))])
    }
}

