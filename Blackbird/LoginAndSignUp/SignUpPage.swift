//
//  LoginPage.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

func createUserFromSpec(username: String, password: String, email: String, image: UIImage, full_name: String) -> ExampleUser{
    return ExampleUser(username: username, full_name: full_name, password: password, bio: "Biography", email: email, avatar: image)
}

struct SignUpPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var input = UserLogin()
    @ObservedObject var nav = Nav()
    @State var user : ExampleUser = ExampleUser(username: "", full_name: "", password: "", bio: "", email: "", avatar: UIImage(named: "my-avatar")!)
    @State var username: String = ""
    @State var email: String = ""
    @State var full_name: String = ""
    @State var password: String = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    func handleSignUp() {
        updateUser(user: createUserFromSpec(username: username, password: password, email: email, image: image, full_name: full_name)) {
            (result) in
            switch result {
            case .success(let exampleUser):
                print("Successful.")
                self.input.currentUser = exampleUser
                self.input.login = true
                username = ""
                email = ""
                password = ""
                
            case .failure(let err):
                print("Big Fat Fucking error")
                print(err.localizedDescription)
            }
        }
    }
    
var body: some View {
    
    if (self.input.login){
        LoginSuccess(login: self.$input.login, username: self.$input.username, settings: self.$nav.settings, messages: self.$nav.messages, currentUser: self.$input.currentUser)
    } else {
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
                }
                Spacer()
                Button(action: {
                                self.isShowPhotoLibrary = true
                            }) {
                                HStack {
                                    if (image != UIImage()){
                                        Image(uiImage: image).resizable().scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Text("Upload Avatar")
                                            .font(.headline)
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                .background((image != UIImage()) ? Color(red: 3/255, green: 15/255, blue: 17/255) : Color(red: 45/255, green: 52/255, blue: 57/255))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                VStack{
                TextField("", text: $username)
                    .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "Username")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10).autocapitalization(.none).textContentType(.username)
                TextField("", text: $full_name)
                    .modifier(PlaceholderStyle(showPlaceHolder: full_name.isEmpty, placeholder: "Full Name")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
                TextField("", text: $email)
                    .modifier(PlaceholderStyle(showPlaceHolder: email.isEmpty, placeholder: "Email")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10).keyboardType(.emailAddress).textContentType(.emailAddress)
                
                SecureField("", text: $password){
                     handleSignUp()
                    }
                .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "Password")).foregroundColor(.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10).textContentType(.password)
                }
                Spacer()
                Button(action:
                        {
                            handleSignUp()
                        }
                    ){Text("Sign Up").frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 1/255, green: 0/255, blue: 0/255)).cornerRadius(10).foregroundColor(.white)}
                
                Spacer()
            }.sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary,  selectedImage: self.$image)
            }
            
        ).navigationBarBackButtonHidden(true).navigationBarItems(leading:
                                                                    Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
                                                                        Text("🕊️ Back").fontWeight(.regular).foregroundColor(.white)
                                                                    })
    }
    
    
    
}
}


struct SignUpPage_Previews : PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
