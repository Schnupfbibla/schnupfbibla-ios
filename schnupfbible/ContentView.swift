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
    @State var showSettings: Bool = false
    
    var body: some View {
        VStack {
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
            
            HStack {
                Button(action: { showSettings = true }, label: {Label("", systemImage: "gear")})
                    .popover(isPresented: $showSettings, arrowEdge: .bottom) {
                        SettingsView().font(.body)
                    }
                Spacer()
                Button(action: {
                    firestoreManager.randomSaying()
                    
                }) {
                    Label("", systemImage: "dice")
                }
                
//                Spacer()
//                Button(action: {
//                    firestoreManager.prevSaying()
//
//                }) {
//                    Label("", systemImage: "arrowtriangle.backward.fill")
//                }
//                Button(action: {
//                    firestoreManager.nextSaying()
//                }) {
//                    Label("", systemImage: "arrowtriangle.forward.fill")
//                }
                Spacer()
                
                Button(action: {
                    firestoreManager.setLikeState()
                }) {
                    Label("", systemImage: firestoreManager.likedSaying() ? "heart.fill" : "heart")
                }

            }.padding(24.0).font(.system(size: 32.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SBDataModel())
    }
}
