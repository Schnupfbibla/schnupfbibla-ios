//
//  FirestoreManager.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseAuth

struct Meta {
    var highestId: Int
}

class SBDataModel: ObservableObject {
    @Published var saying: Saying? = nil
    @Published var meta: Meta = Meta(highestId: 0)
    @AppStorage("index") var index: Int = 0
    @AppStorage("docId") var docId: String = ""
    @AppStorage("vulgarContentAllowed") var vulgarContentAllowed: Bool = false

    @Published var user: DBUser? = nil
    
    @Published var titles: Dictionary<String, String> = [:]

    public var fbuser: User? = nil
    public var nonce: String = "";
    
    
    init() {
        randomSaying()
        
        if (Auth.auth().currentUser?.uid != nil) {
            persistentLogin()
        } else {
            loginAnon()
        }
    }
    
}
