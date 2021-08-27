//
//  MessageContent.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color(red: 3/255, green: 15/255, blue: 17/255) : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}


struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: DataSource.messages[0].content, isCurrentUser: DataSource.messages[0].user.isCurrentUser)
    }
}
