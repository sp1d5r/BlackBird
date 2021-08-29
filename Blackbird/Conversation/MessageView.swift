//
//  Message.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI


struct MessageView : View {
    var currentMessage: [Message] // grouped by username
    var avatar : UIImage
    var myUsername: String
    var body: some View {
        VStack {
                ForEach(0..<currentMessage.count-1) { ind in
                    HStack(alignment: .bottom, spacing: 15){
                        if currentMessage[ind].sender == myUsername  {
                            Spacer()
                        }
                        ContentMessageView(contentMessage: currentMessage[ind].body,
                                       isCurrentUser: currentMessage[ind].sender == myUsername)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 15) {
                    if currentMessage[currentMessage.count - 1].sender != myUsername {
                        Image(uiImage: avatar)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(20)
                    } else {
                        Spacer()
                    }
                    ContentMessageView(contentMessage: currentMessage[currentMessage.count - 1].body,
                                   isCurrentUser: currentMessage[currentMessage.count-1].sender == myUsername)
                }
            
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding()
    }
}

