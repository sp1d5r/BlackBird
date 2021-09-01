//
//  AuthenticatedScreen.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 29/08/2021.
//

import Foundation
import SwiftUI

struct LoginForum : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authentication: Authentication
    
    
    @State var loggingIn : Bool = false
    @State var password: String = ""
    @State var changing = false
    @State var error = false
    @State var loading = false
    @Binding var login : Bool
    @Binding var username: String
    @Binding var currentUser : ExampleUser
    @Binding var storedCredentials: Bool
    
    
    
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
                
                HStack{
                    Button(action: {
                        if (username != "" && password != ""){
                            loading = true
                            print("makes it here")
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
                                loading = false
                            case .failure(let err):
                                error = true
                                print(err.localizedDescription)
                                loading = false
                            }
                        }
                        } else {
                            error = true
                        }
                    }){
                        Text("Login").frame(width: UIScreen.screenWidth * 5 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 1/255, green: 0/255, blue: 0/255)).cornerRadius(10).foregroundColor(.white)
                        
                    }.disabled(loading)
                    
                    if authentication.theType() != .none  && !loading {
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
                                        loading = false
                                    case .failure(let err):
                                        error = true
                                        print(err.localizedDescription)
                                        loading = false
                                    }
                                }
                                
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
                
                Spacer()
            }.opacity(changing ? 0 : 1)
        ).navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss()}) { Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)})
    }
    
}
