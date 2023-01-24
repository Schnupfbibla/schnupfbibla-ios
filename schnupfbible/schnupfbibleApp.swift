//
//  schnupfbibleApp.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
    return true
  }
    func applicationDidBecomeActive(_ application: UIApplication) {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

@main
struct schnupfbibleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreManager = SBDataModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firestoreManager)
        }
    }
}
