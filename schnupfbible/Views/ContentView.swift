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
                SettingsButtonView().accessibilityIdentifier("settingsButton")
                Spacer()
                
                RandomButtonView().accessibilityIdentifier("randomButton")
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
                LikeButtonView().accessibilityIdentifier("likeButton")


            }.padding(24.0).font(.system(size: 32.0))
        }
    }
}
struct SayingViewWrapper: View {
    @AppStorage("setupCompleted") private var setupCompleted: Bool = false
    @State private var showWelcomeSheet: Bool = false
    var body: some View {
        SayingView()
            .onAppear {
                print("setup was\(setupCompleted ? "" : " not") completed.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Change `2.0` to the desired number of seconds.
                   // Code you want to be delayed
                    if (!setupCompleted) {
                        showWelcomeSheet = true
                    }
                }
                
            }
            .welcomeSheet(isPresented: $showWelcomeSheet, onDismiss: {
                setupCompleted = true
            }
            , pages: OnboardingWelcomeSheetPages)
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
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
