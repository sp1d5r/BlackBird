//
//  Settings.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 28/08/2021.
//

import Foundation
import SwiftUI

struct Settings : View {
    @Binding var opacity1 : Double
    @Binding var settings : Bool
    @Binding var messages : Bool
    @Binding var login : Bool
    @Binding var currentUser: ExampleUser
    
    
    var body: some View {
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
                    TextField("", text: $currentUser.username)
                        .modifier(PlaceholderStyle(showPlaceHolder: currentUser.username.isEmpty, placeholder: currentUser.username)).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                    Text("Update email").foregroundColor(.white).padding()
                    TextField("", text: $currentUser.email)
                        .modifier(PlaceholderStyle(showPlaceHolder: currentUser.email.isEmpty, placeholder: currentUser.email)).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                    Text("Update password").foregroundColor(.white).padding()
                    SecureField("", text: $currentUser.password)
                        .modifier(PlaceholderStyle(showPlaceHolder: currentUser.password.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                    Text("Update avatar").foregroundColor(.white).padding()
                    Button(action: {print("I'm supposed to handle avatar updates.")}) {
                        Text("Update Avatar").foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                    }
                    Button(action: {print("Update deails ")}) {
                        Text("Update Details").foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 100/255, blue: 57/255)).cornerRadius(10).padding()
                    }
                    Button(action: {logOut(login: &login, settings: &settings)}) {
                        Text("Log Out").foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 100/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        ).navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
