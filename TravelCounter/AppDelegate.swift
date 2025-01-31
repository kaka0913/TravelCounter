//
//  AppDelegate.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import UIKit
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // GoogleService-Info.plistから直接CLIENT_IDを取得
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plistDict = NSDictionary(contentsOfFile: filePath) {
            if let clientID = plistDict["CLIENT_ID"] as? String {
                GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
