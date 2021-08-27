//
//  ContentView.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 24/08/2021.
//

import SwiftUI


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}


func print1(value: String) {
    print("value : \(value)")
}


/*
 
 Background View - contains the rectangles and their animations
 
 */

struct TopRectangle: View {
    @State var opacity: Double = 0
var body: some View {

return Rectangle()
    .foregroundColor(Color(red: 168/255, green: 168/255, blue: 168/255))
    .shadow(radius: 100)
    .cornerRadius(10)
    .rotationEffect(.degrees(75))
    .position(x:20, y:50)
    .frame(width: UIScreen.screenWidth/7, height: UIScreen.screenWidth/7, alignment: .center)
    .animation(.default)
    .opacity(opacity)
    .animation(.easeInOut(duration: 2))
    .onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            opacity = 1
        }
    }
   }
}

struct MiddleRectangle: View {
    @State var opacity: Double = 0
var body: some View {

return Rectangle()
    .foregroundColor(Color(red: 168/255, green: 168/255, blue: 168/255))
    .shadow(radius: 100)
    .cornerRadius(25)
    .rotationEffect(.degrees(60))
    .position(x:0, y:200)
    .frame(width: UIScreen.screenWidth/3, height: UIScreen.screenWidth/3, alignment: .center)
    .animation(.default)
    .opacity(opacity)
    .animation(.easeInOut(duration: 1))
    .onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            opacity = 1
        }
    }
   }
}

struct BottomRectangle: View {
    @State var opacity: Double = 0
var body: some View {

return Rectangle()
    .foregroundColor(Color(red: 168/255, green: 168/255, blue: 168/255))
    .shadow(radius: 100)
    .cornerRadius(33)
    .frame(width: UIScreen.screenWidth/1.12, height: UIScreen.screenWidth/1.12)
    .rotationEffect(.degrees(Double(45)))
    .position(x:UIScreen.screenWidth/1.5, y:UIScreen.screenHeight*3.7/8)
    .opacity(opacity)
    .animation(.easeInOut(duration: 1))
    .onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            opacity = 1
        }
    }
   }
}


struct BackgroundView: View {
    var body: some View {
        Color(red: 3/255, green: 15/255, blue: 17/255).ignoresSafeArea().overlay(
            VStack{
                TopRectangle()
                MiddleRectangle()
                BottomRectangle()
        })
    }
}

/*
 
 Content View - Contains the login and signup options
 
 */
struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
            Text("BlackBird \n      Messenger")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading).padding(.horizontal, 100)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .position(x: UIScreen.screenWidth/5, y: UIScreen.screenHeight/2)
            NavigationLink(destination: LoginPage()){
                Text(" Login").font(.headline).fontWeight(.bold).foregroundColor(Color.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
            }.position(x: UIScreen.screenWidth/2, y: UIScreen.screenHeight/3)
            
            NavigationLink(destination: SignUpPage()){
                Text("Sign Up").font(.headline).fontWeight(.bold).foregroundColor(Color.white).frame(width: UIScreen.screenWidth * 7 / 8, height: UIScreen.screenHeight / 14).background(Color(red: 45/255, green: 52/255, blue: 57/255)).cornerRadius(10)
            }.position(x: UIScreen.screenWidth/2, y: UIScreen.screenHeight/7)
        })
    }
}


struct BackgroundStack: View {
    @State var opacity: Double = 0
    var body: some View {
        NavigationView{
        ZStack() {
            BackgroundView()
            ContentView().opacity(opacity)
                .animation(.easeInOut(duration: 2))
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        opacity = 1
                    }
                }
        }
        }
    }
}
