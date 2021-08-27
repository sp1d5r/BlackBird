//
//  LoginPage.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

class UserLogin: ObservableObject {
    @Published var login = false
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
    
    @State var password: String = ""
    @State var changing = false
    @Binding var login : Bool
    @Binding var username: String
    
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
                Spacer()
                TextField("", text: $username)
                    .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "Username")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                
                
                TextField("", text: $password)
                    .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                Spacer()
                Spacer()
                Button(action: {handleLogin()}){Text("Login").frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 1/255, green: 0/255, blue: 0/255)).cornerRadius(10).foregroundColor(.white)}
                
                Spacer()
            }.opacity(changing ? 0 : 1)
        ).navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss()}) { Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)})
    }
    
}

func goToUser(username: String, messages: inout Bool){
    print("hello")
    messages = !messages
}

func returnFromUser(messages : inout Bool){
    messages = !messages
}

func goToSettings(settings: inout Bool) {
    print("I am going to settings")
    settings = !settings
}

func logOut(login: inout Bool){
    login = !login
}

struct LoginSuccess : View {
    @State var changing = false
    @State var opacity1 : Double = 0
    @State var opacity2 : Double = 0
    @Binding var login : Bool
    @Binding var username: String
    
   // Navigation Booleans
    @Binding var settings : Bool
    @Binding var messages : Bool
    @Binding var currentUser : ExampleUser
    
    
    
    
    var body: some View {
        
        if (settings) {
            Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
                VStack(alignment: .leading){
                    HStack{
                        
                        Button(action: {goToSettings(settings: &settings)}) {
                            Text("Back").fontWeight(.bold).foregroundColor(Color.white).padding()
                        }
                        VStack{Rectangle().frame(maxWidth: .infinity, maxHeight: 1.0,  alignment: .bottom)
                            .foregroundColor(Color.white)
                        }
                        
                    
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight / 10).opacity(opacity1)
                    .animation(.easeInOut(duration: 2))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            opacity1 = 1
                        }
                    }
                    VStack{
                        Text("Update username").foregroundColor(.white)
                        TextField("", text: $username)
                            .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: currentUser.username)).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                        Text("Update email").foregroundColor(.white).padding()
                        TextField("", text: $username)
                            .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: currentUser.email)).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                        Text("Update password").foregroundColor(.white).padding()
                        TextField("", text: $username)
                            .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                        Text("Update avatar").foregroundColor(.white).padding()
                        Button(action: {print("I'm supposed to handle avatar updates.")}) {
                            Text("Update Avatar").foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                        }
                        Button(action: {logOut(login: &login)}) {
                            Text("Log Out").foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 100/255, green: 52/255, blue: 57/255)).cornerRadius(10).padding()
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            ).navigationBarTitle("")
            .navigationBarHidden(true)
            
        } else if (messages){
            ConversationView(messages: $messages).navigationBarTitle("")
                .navigationBarHidden(true)
        } else {
            Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
                VStack(alignment: .leading){
                    HStack{
                        VStack{Rectangle().frame(maxWidth: .infinity, maxHeight: 1.0,  alignment: .bottom)
                            .foregroundColor(Color.white)
                        }
                        Button(action: {goToSettings(settings: &settings)}) {
                            Text("Elijah Ahmad").fontWeight(.bold).foregroundColor(Color.white).padding()
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
                        List {
                            
                            // The Button I just Made
                            
                            Button(action : {goToUser(username: "hello", messages: &messages)}) {
                                HStack{
                                    Image(uiImage: currentUser.avatar)
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(25)
                                    VStack{
                                        HStack{
                                            Text(currentUser.username).fontWeight(.medium).foregroundColor(.white)
                                            Circle().frame(maxWidth: 5, maxHeight: 5).foregroundColor(.white)
                                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                                        Text("Hey Sexy, when are you coming? home broski! ").fontWeight(.thin).foregroundColor(.white).frame(maxWidth: .infinity, maxHeight: 50)
                                    }.frame(maxWidth: UIScreen.screenWidth*3/4, alignment: .topLeading)
                                }
                            }.listRowBackground(Color(red: 3/255, green: 15/255, blue: 17/255))
                            
                            // END OF BUTTON
                                
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
            .navigationBarHidden(true)
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
            LoginSuccess(login: self.$input.login, username: self.$input.username, settings: self.$nav.settings, messages: self.$nav.messages, currentUser: self.$input.currentUser)
        } else {
            LoginForum(login: self.$input.login, username: self.$input.username)
        }
        
    }
    
}


struct LoginPage_Previews : PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
