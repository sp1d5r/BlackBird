//
//  LoginPage.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI


struct SignUpPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
var body: some View {
    Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
        VStack{
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
            TextField("", text: $email)
                .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "Email")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
            
            TextField("", text: $password)
                .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
            Spacer()
            Button(action: {print("signing in")}){Text("Sign Up").frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 1/255, green: 0/255, blue: 0/255)).cornerRadius(10).foregroundColor(.white)}
            
            Spacer()
        }
        
    ).navigationBarBackButtonHidden(true).navigationBarItems(leading:
                                                                Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
                                                                    Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)
                                                                })
}
}
