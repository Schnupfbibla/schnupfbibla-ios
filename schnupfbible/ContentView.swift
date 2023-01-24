//
//  ContentView.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI
import WelcomeSheet
import AppTrackingTransparency
import FirebaseCore

struct ContentView: View {
    
    @EnvironmentObject var firestoreManager: SBDataModel
    
    @AppStorage("firstLaunch") private var showWelcomeSheet: Bool = true
    @State private var showIntersitialAd: Bool = false
    
    @State private var scrollCount = 0
    
    var body: some View {
        NavigationView() {
            SayingView()
                .welcomeSheet(isPresented: $showWelcomeSheet, onDismiss: {
                    showWelcomeSheet = false
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: {
                        status in
                                    switch status {
                                        case .authorized:
                                            print("enable tracking")
                                        case .denied:
                                            print("disable tracking")
                                        default:
                                            print("disable tracking")
                                    }
                    })
                }, pages: OnboardingWelcomeSheetPages)
                .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    NavigationLink(destination: SettingsView()) {
                        Label("", systemImage: "gear")
                    }
                    Spacer()
                    Button(action: {
                        firestoreManager.prevSaying()
                        
                    }) {
                        Label("", systemImage: "arrowtriangle.backward.fill")
                    }
                    Button(action: {
                        firestoreManager.nextSaying()
                    }) {
                        Label("", systemImage: "arrowtriangle.forward.fill")
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SBDataModel())
    }
}
