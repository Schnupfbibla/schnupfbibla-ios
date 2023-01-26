//
//  AccountDataModel.swift
//  schnupfbible
//
//  Created by Jesse Born on 25.01.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

extension SBDataModel {
    
    func loginAnon() {
        Auth.auth().signInAnonymously(completion: {
            res, err in
            self.fbuser = res?.user
            print("[ SignIn ] signed in succ with \(self.fbuser?.uid ?? "was nil")")
            
            self.user = DBUser(uid: self.fbuser?.uid ?? "", anon: true, likedSayings: [])
            self.createUserDataDoc()
        })
        
    }
    
    func persistentLogin() {
        self.fbuser = Auth.auth().currentUser
        self.user = DBUser(uid: Auth.auth().currentUser?.uid ?? "", anon: Auth.auth().currentUser?.isAnonymous ?? false, likedSayings: [])
        self.createUserDataDoc()
    }
    
    func createUserDataDoc() {
        let db = Firestore.firestore()
        
        let ref = db.collection("userData").document("\(self.user?.uid ?? "")")
        
        ref.getDocument(completion: {
            snapshot, err in
            if(!(snapshot?.exists ?? false)) {
                ref.setData([
                    "likedSayings": self.user?.likedSayings ?? []
                ])
            } else {
                
                let d = snapshot?.data()
                self.user = DBUser(uid: self.user?.uid ?? "", anon: self.user?.anon ?? true, likedSayings: d?["likedSayings"] as! [String], email: d?["email"] as? String, displayName: d?["displayName"] as? String)
                print("[ SignIn ] returning user, loaded data:", self.user ?? "")
            }
        })
    }
    
    func writeUserDataDoc() {
        let db = Firestore.firestore()
        
        let ref = db.collection("userData").document("\(self.user?.uid ?? "")")
        
        ref.updateData([
            "likedSayings": self.user?.likedSayings ?? [],
        ])
    }
    func writeUserDataDoc(displayName: String, email: String) {
        let db = Firestore.firestore()
        
        let ref = db.collection("userData").document("\(self.user?.uid ?? "")")
        
        ref.updateData([
            "displayName": displayName,
            "email": email,
            "likedSayings": FieldValue.arrayUnion(self.user?.likedSayings ?? []),
        ])
    }
    
    func setLikeState() {
        
        if (!likedSaying()) {
            self.user?.likedSayings.append(self.saying?.name ?? "")
        } else {
            self.user?.likedSayings = (self.user?.likedSayings ?? []).filter({$0 != self.saying?.name})
        }
        self.writeUserDataDoc()
    }
    
    func likedSaying() -> Bool {
        return (self.user?.likedSayings ?? []).contains(self.saying?.name ?? "")
    }
    
    func doSignIn(appleIDCredential: ASAuthorizationAppleIDCredential, fbres: AuthDataResult) {
        self.fbuser = fbres.user
        print("[ SignIn ] signed in succ with \(self.fbuser?.uid ?? "was nil")")
        self.user = DBUser(uid: self.fbuser?.uid ?? "", anon: false, likedSayings: self.user?.likedSayings ?? [])
        self.createUserDataDoc()
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        self.loginAnon()
    }
}
