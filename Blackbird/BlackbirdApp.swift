//
//  BlackbirdApp.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 24/08/2021.
//

import SwiftUI
import CloudKit
import UIKit

@main
struct BlackbirdApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    init() {
            UITableView.appearance().backgroundColor = .clear
        }

    var body: some Scene {
        WindowGroup {
            BackgroundStack()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     return true
    }
//No callback in simulator
//-- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        print("Gets here")
        let cloudKitNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String: NSObject])
        if cloudKitNotification?.notificationType == CKNotification.NotificationType.query {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "performReload"), object: nil)
            }
        }
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        badgeReset()
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}


func badgeReset() {
    let resetBadge = CKModifyBadgeOperation(badgeValue: 0)
    resetBadge.modifyBadgeCompletionBlock = { (error) -> Void in
        if error != nil {
            print(error ?? "Error")
        }
        else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    CKContainer.default().add(resetBadge)
}
