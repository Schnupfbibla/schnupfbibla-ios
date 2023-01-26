//
//  ContentView.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI
import WelcomeSheet
import FirebaseCore

struct ContentView: View {
    
    var body: some View {
        VStack {
            SayingViewWrapper()
            
            HStack {
                let _ = Self._printChanges()
                SettingsButtonView()
                Spacer()
                
                RandomButtonView()
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
                LikeButtonView()


            }.padding(24.0).font(.system(size: 32.0))
        }
    }
}
struct SayingViewWrapper: View {
    @AppStorage("firstLaunch") private var showWelcomeSheet: Bool = true
    
    var body: some View {
        SayingView()
            .welcomeSheet(isPresented: $showWelcomeSheet, onDismiss: {
                showWelcomeSheet = false
            }, pages: OnboardingWelcomeSheetPages)
    }
}

struct RandomButtonView: View {
    
    @EnvironmentObject var firestoreManager: SBDataModel
    
    var body: some View {
        Button(action: {
            firestoreManager.randomSaying()
            
        }) {
            Label("", systemImage: "dice")
        }

    }
}
struct LikeButtonView: View {
    
    @EnvironmentObject var firestoreManager: SBDataModel
    
    var body: some View {
        Button(action: {
            firestoreManager.setLikeState()
        }) {
            Label("", systemImage: firestoreManager.likedSaying() ? "heart.fill" : "heart").foregroundColor(firestoreManager.likedSaying() ? .red : .blue)
        }
    }
}
struct SettingsButtonView: View {
    
    @State var showSettings: Bool = false
    
    var body: some View {
        Button(action: { showSettings.toggle() }, label: {Label("", systemImage: "gear")})
            .popover(isPresented: $showSettings, arrowEdge: .bottom) {
                SettingsView().font(.body)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SBDataModel())
    }
}


