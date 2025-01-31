//
//  TravelCounterApp.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct TravelCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    // 既存のサインイン状態を確認
                    if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                        GIDSignIn.sharedInstance.restorePreviousSignIn()
                    }
                }
        }
    }
}
