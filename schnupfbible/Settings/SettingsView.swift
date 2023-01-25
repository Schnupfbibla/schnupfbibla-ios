//
//  SettingsView.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("vulgarContentAllowed") private var vulgarContentAllowed: Bool = false
    
    @ObservedObject private var viewModel: SubmissionViewModel
    @EnvironmentObject var firestoreManager: SBDataModel
    
    @State private var showThankYouSheet: Bool = false
    
    init(viewModel: SubmissionViewModel = SubmissionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Einstellungen").font(.title2)
                Spacer()
                Button(action: {dismiss()}) {
                    Label("", systemImage: "xmark.circle.fill").font(.system(size: 32.0)).foregroundColor(.gray)
                }
            }.padding(12.0)
            List {
                Section() {
                    Toggle("Explizite Inhalte erlauben", isOn: $vulgarContentAllowed)
                }
                
                Section(header: Text("LIEBLINGSSPRÜCHE")) {
                    ForEach(firestoreManager.user?.likedSayings ?? [], id: \.self) {saying in
                        
                        Button("\(saying)") {
                            firestoreManager.fetchSaying(uid: saying)
                            dismiss()
                        }
                    }
                    if ((firestoreManager.user?.likedSayings ?? []) == []) {
                        Text("Noch nichts geliked")
                    }
                }
                
                Section(header: Text("SPRUCH EINREICHEN"), footer: Text("Sprüche werden in der Regel innerhalb von 2-5 Tagen gesichtet und sind anschliessend für alle Nutzer verfügbar.\nRassistische Inhalte werden nicht akzeptiert!")) {
                    TextField("Spitzname", text: $viewModel.name)
                    TextField("E-Mail", text: $viewModel.email).keyboardType(.emailAddress)
                    TextField("Titel", text: $viewModel.titel)
                    TextField("Spruch", text: $viewModel.bodytext,  axis: .vertical)
                        .lineLimit(10...20)
                    Button("Spruch Einreichen", action: {
                        firestoreManager.addSubmission(submission: Submission(title: viewModel.titel, content: viewModel.bodytext, email: viewModel.email, name: viewModel.name))
                        viewModel.clear()
                        showThankYouSheet.toggle()
                    }).disabled(!viewModel.formIsValid)
                        .welcomeSheet(isPresented: $showThankYouSheet, pages: SubmissionThankYouPages)
                }
//                Section {
//
//                }
                Section {
                    if (firestoreManager.user?.anon ?? true) {
                        SignInWithAppleButton(onRequest: {request in
                            request.requestedScopes = [.email, .fullName]
                            firestoreManager.nonce = randomNonceString()
                            request.nonce = sha256(firestoreManager.nonce)
                        }, onCompletion: {res in
                            do {
                                let appleidcredential = try res.get().credential as? ASAuthorizationAppleIDCredential
                                guard let token = appleidcredential?.identityToken else {
                                    print("Unable to fetch identity")
                                    return
                                }
                                guard let idTokenString = String(data: token, encoding: .utf8) else { // (3)
                                    print("Unable to serialise token string from data: \(token.debugDescription)")
                                    return
                                }
                                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                          idToken: idTokenString,
                                                                          rawNonce: firestoreManager.nonce)
                                firestoreManager.fbuser?.link(with: credential) { (result, error) in
                                    if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                                        print("User already linked.")
                                    }
                                    if let updatedCredential = (error as? NSError)?.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                                        print("Signing in using new cred")
                                        Auth.auth().signIn(with: updatedCredential) { (result, error) in
                                            if let user = result?.user {
                                                // TODO: handle data migration
                                                print("Needs migration")
                                                firestoreManager.doSignIn(appleIDCredential: appleidcredential!, fbres: result!) // (3)
                                            }
                                        }
                                    }
                                    else if let error = error {
                                        print("Error trying to link user: \(error.localizedDescription)")
                                    }
                                    else {
                                        if let user = result?.user {
                                            firestoreManager.doSignIn(appleIDCredential: appleidcredential!, fbres: result!)
                                        }
                                    }
                                }
                                
                            }
                            catch {
                                print("Error: \(error.localizedDescription)")
                            }
                            
                        })
                    } else {
                        Button("Abmelden") {
                            firestoreManager.signOut()
                        }
                    }
                }
            }.navigationTitle(Text("Einstellungen"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
