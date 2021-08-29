//
//  LoginPage.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI
import CloudKit

class UserLogin: ObservableObject {
    @Published var login = false
    @Published var storedCredentials = false
    @Published var username = ""
    @Published var fullname = ""
    @Published var currentUser : ExampleUser = ExampleUser(username: "", full_name: "", password: "", bio: "", email: "", avatar: UIImage(named: "my-avatar")!)
}

class Nav: ObservableObject {
    @Published var messages = false
    @Published var settings = false
}

struct LoginForum : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authentication: Authentication
    
    @State var password: String = ""
    @State var changing = false
    @State var error = false
    @State var loading = false
    @Binding var login : Bool
    @Binding var username: String
    @Binding var currentUser : ExampleUser
    @Binding var storedCredentials: Bool
    
    
    func handleLogin() {
        if (username == "Elijah" && password == ""){
            changing = true
            do {
                sleep(2)
            }
            self.login = true
        }
    }
    
    var body: some View {
        Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
            VStack{
                Spacer()
                Spacer()
                HStack{
                    Text("BlackBird \n      Messenger")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading).padding(.horizontal, 40)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                if (error) {Text("Login Failed").foregroundColor(Color(red: 100/255, green: 52/255, blue: 57/255))} else {Spacer()}
                TextField("", text: $username)
                    .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "Username")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10).autocapitalization(.none).textContentType(.username).disableAutocorrection(true)
                
                
                SecureField("", text: $password)
                    .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10).textContentType(.password)
                Spacer()
                Spacer()
                Button(action: {
                        loading = true
                        tryLogin(username: username, password: password){(result) in
                        switch result {
                        case .success(let user):
                            currentUser = user
                            if !storedCredentials {
                                if KeyChainStorage.saveCredentials(Credentials(username: username, password: password)) {
                                    print("Credentials Saved")
                                    storedCredentials = true
                                }
                            }
                            print("Successfullly Logged in baby!!")
                            login = true
                        case .failure(let err):
                            error = true
                            print(err.localizedDescription)
                        }
                    }
                    loading = false
                }){
                    if (!loading) {
                        HStack {
                            Text("Login").frame(width: UIScreen.screenWidth * 5 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 1/255, green: 0/255, blue: 0/255)).cornerRadius(10).foregroundColor(.white)
                            if authentication.theType() != .none {
                                
                                Button {
                                    authentication.requestBiometricUnlock {
                                        (result) in
                                        switch result {
                                        case .success(let credentials):
                                            username = credentials.username
                                            password = credentials.password
                                            
                                            loading = true
                                            tryLogin(username: username, password: password){(result) in
                                            switch result {
                                            case .success(let user):
                                                currentUser = user
                                                print("Successfullly Logged in baby!!")
                                                login = true
                                            case .failure(let err):
                                                error = true
                                                print(err.localizedDescription)
                                            }
                                        }
                                        loading = false
                                        case .failure(let error):
                                            print(error)
                                            
                                        }
                                    }
                                } label : {
                                    Image(systemName: authentication.theType() == .face ? "faceid" : "touchid")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    } else {
                        Text("Loading").frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 100/255, blue: 57/255)).cornerRadius(10).foregroundColor(Color(.white))
                    }
                }
                Spacer()
            }.opacity(changing ? 0 : 1)
        ).navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss()}) { Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)})
    }
    
}



func returnFromUser(messages : inout Bool){
    messages = !messages
}

func goToSettings(settings: inout Bool) {
    print("I am going to settings")
    settings = !settings
}

func logOut(login: inout Bool, settings: inout Bool){
    login = !login
    settings = false
}

class ObservableConversation : ObservableObject {
    @Published var conversations : [Conversation] = []
    @Published var convoUsers : [ExampleUser] = []
}

struct LoginSuccess : View {
    
    @State var changing = false
    @State var opacity1 : Double = 0
    @State var opacity2 : Double = 0
    @State var newUsername : String = ""
    @State var home : Bool = true
    @Binding var login : Bool
    
   // Navigation Booleans
    @Binding var settings : Bool
    @Binding var messages : Bool
    @Binding var currentUser : ExampleUser
    typealias FinishedDownload = () -> ()
    
    @StateObject var observableConversations = ObservableConversation()
    @State var currentConversation: String = ""
    @State var currentConvoUser: ExampleUser = ExampleUser(username: "", full_name: "", password: "", bio: "", email: "", avatar: UIImage())
    
    
    func goToUser(username: String, messages: inout Bool) {
        // These should always be true,
        print("Looking for the username :", username)
        for conversation in observableConversations.conversations {
            if conversation.users.contains(username) {
                currentConversation = conversation.recordID?.recordName ?? ""
                print("Found the username with convoid", currentConversation)
                messages = true
            }
        }
        print("Looking for the user ")
        let user = isInConvoUsers(username: username)
        if (user != nil){
            print("Found it! ")
            currentConvoUser = user!
        } else {
            messages = false
        }
    }
    
    func initialUpdateConversation(completed: FinishedDownload) {
        print("Intiial Update")
        
        getConversations(username: currentUser.username){(result) in
            switch result {
            case .success(let conversation):
                print("Succesffully got conversation")
                print(conversation.id)
                if (!observableConversations.conversations.contains(conversation)){
                    observableConversations.conversations.append(conversation)
                    updateConversations()
                }
            case .failure(let error):
                print("Failure getting initial conversations.")
                print(error)
            }
        }
    }
    
    func updateConversations(){
        for conversation in observableConversations.conversations.uniqued(){
            print("Conversation: ", conversation.users)
            let otherUser = (conversation.users[0] == currentUser.username) ? conversation.users[1] : conversation.users[0]

            getUserDetails(username: otherUser) {(record) in
                switch record{
                case .success(let exampleUser):
                    if (!(observableConversations.convoUsers.contains(exampleUser))){
                        print("Added user %@ to convo users", exampleUser.username)
                        observableConversations.convoUsers.append(exampleUser)
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    func isInConvoUsers(username: String) -> ExampleUser?{
        for user in observableConversations.convoUsers{
            if (user.username == username) {
                return user
            }
        }
        return nil
    }
    
    var body: some View {
        
        if (settings) {
            Settings(opacity1: $opacity1, settings: $settings, messages: $messages, login: $login, currentUser: $currentUser)
        } else if (messages){
            ConversationView(messages: $messages,
                             conversationID: $currentConversation,
                             currentUser: $currentUser,
                             otherUser: $currentConvoUser
                             ).navigationBarTitle("")
                .navigationBarHidden(true)
        } else {
            Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
                VStack(alignment: .leading){
                    HStack{
                        VStack{Rectangle().frame(maxWidth: .infinity, maxHeight: 1.0,  alignment: .bottom)
                            .foregroundColor(Color.white)
                        }
                        Button(action: {goToSettings(settings: &settings)}) {
                            Text(currentUser.full_name).fontWeight(.bold).foregroundColor(Color.white).padding()
                        }
                            
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight / 7).opacity(opacity1)
                    .animation(.easeInOut(duration: 2))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            opacity1 = 1
                        }
                    }
                    VStack{
                        HStack {
                            Spacer()
                            TextField("", text: $newUsername)
                                .modifier(PlaceholderStyle(showPlaceHolder: newUsername.isEmpty, placeholder: "username")).foregroundColor(.white).frame(maxWidth: .infinity).background(Color(red: 25/255, green: 32/255, blue: 37/255)).cornerRadius(10).disableAutocorrection(true).autocapitalization(.none)
                            Button {
                                if (newUsername != currentUser.username && newUsername != "" && isInConvoUsers(username: newUsername) == nil){
                                    createConversation(user1: currentUser.username, user2: newUsername) {(record) in
                                        switch record{
                                        case .success(let conversation):
                                            print("Successfully created a conversation.")
                                            print(conversation.id)
                                            // Now get user data
                                            if (!(observableConversations.conversations.contains(conversation))){
                                                print("here")
                                                observableConversations.conversations.append(conversation)
                                                updateConversations()
                                            }
                                            
                                        case .failure(let error):
                                            print("Failed to create conversation, with %@ and %@", [newUsername, currentUser.username])
                                            print(error)
                                        }
                                    }
                                }
                                newUsername = ""
                            } label : {
                                Text("Add User").foregroundColor(.white).padding(.horizontal, 5)
                                Image(systemName: "paperplane.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20).foregroundColor(.white).padding(.trailing, 5).padding()
                            }
                            
                        }
                        List() {
                            
                            // The Button I just Made
                            
                            HStack{
                                Text("Associates").foregroundColor(.white)
                                
                            }.listRowBackground(Color(red: 3/255, green: 15/255, blue: 17/255))
                            
                            // END OF BUTTON
                            
                            ForEach(observableConversations.convoUsers, id: \.username) { user in
                                
                                Button(action : {goToUser(username: user.username, messages: &messages)}) {
                                    HStack{
                                        Image(uiImage: user.avatar)
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .cornerRadius(25)
                                        VStack{
                                            HStack{
                                                Text(user.full_name).fontWeight(.medium).foregroundColor(.white)
                                                Circle().frame(maxWidth: 5, maxHeight: 5).foregroundColor(.white)
                                            }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                                            Text("Hey Sexy, when are you coming? home broski!").fontWeight(.thin).foregroundColor(.white).frame(maxWidth: .infinity, maxHeight: 50)
                                        }.frame(maxWidth: UIScreen.screenWidth*3/4, alignment: .topLeading)
                                    }
                                }.listRowBackground(Color(red: 3/255, green: 15/255, blue: 17/255))
                            }
                            
                                
                        }
                        .opacity(0.7).onAppear {
                                // Set the default to clear
                                UITableView.appearance().backgroundColor = .clear
                            }
                    }.frame(maxWidth: .infinity, maxHeight:.infinity).opacity(opacity2)
                    .animation(.easeInOut(duration: 2))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            opacity2 = 1
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            ).navigationBarTitle("")
            .navigationBarHidden(true).onAppear(perform: {
                
                // To deal with this just keep conversations here and keep user ID's in a separate page.
                // so deal with for loops using conversations here and then return a new view
                // this will grab the other user details render them. It'll also deal with
                // updating the user details. 
                
               initialUpdateConversation{() -> () in print("Gets here")}
                initialUpdateConversation{() -> () in print("Gets here")}
            })
        }
    }
    
}


struct LoginPage: View {
    @ObservedObject var input = UserLogin()
    @ObservedObject var nav = Nav()
    
    init() {
            UITableView.appearance().backgroundColor = .clear
        }
    
    var body : some View {
        if (self.input.login) {
            LoginSuccess(login: self.$input.login, settings: self.$nav.settings, messages: self.$nav.messages, currentUser: self.$input.currentUser)
        } else {
            LoginForum(login: self.$input.login, username: self.$input.username, currentUser: self.$input.currentUser, storedCredentials: self.$input.storedCredentials).environmentObject(Authentication())
        }
        
    }
    
}


struct LoginPage_Previews : PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
