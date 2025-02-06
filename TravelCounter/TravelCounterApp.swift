//
//  TravelCounterApp.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

@main
struct TravelCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isAuthenticated") private var isAuthenticated = false
    @AppStorage("hasCompletedProfileSetup") private var hasCompletedProfileSetup = false
    
    init() {}
    
    var body: some Scene {
        WindowGroup {
            Group {
               if !isAuthenticated {
                   AuthView()
                       .onOpenURL { url in
                           GIDSignIn.sharedInstance.handle(url)
                       }
                       .onAppear {
                           // 既存のサインイン状態を確認
                           if Auth.auth().currentUser != nil {
                               isAuthenticated = true
                           }
                           if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                               GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                                   if user != nil && error == nil {
                                       isAuthenticated = true
                                   }
                               }
                           }
                       }
               } else if !hasCompletedProfileSetup {
                   ProfileSettingView(onComplete: {
                       hasCompletedProfileSetup = true
                   })
               } else {
                   PrefectualMapOfJapanView()
               }
            }
        }
    }
}
