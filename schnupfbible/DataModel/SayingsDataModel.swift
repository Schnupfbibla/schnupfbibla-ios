//
//  SayingsDataModel.swift
//  schnupfbible
//
//  Created by Jesse Born on 25.01.23.
//

import Foundation
import FirebaseFirestore

extension SBDataModel {
    
    func fetchSaying(uid: String) {
            let db = Firestore.firestore()
    
            print("[ Fetch ] saying with uid \(uid)")
            let docRef = db.collection("sayings").document("\(uid)")
    
            docRef.getDocument { [self] (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }
    
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        print("saying", data)
    
                        self.saying = Saying(title: data["title"] as? String ?? "", paragraphs: data["paragraphs"] as? [String] ?? [], author: data["author"] as? String ?? "", explicit: data["explicit"] as? Bool ?? true, id: data["id"] as? Int ?? 0, name: document.documentID)
                        
                    }
                }
    
            }
        }
        
        func randomSaying() {
            let db = Firestore.firestore()
            let subm = db.collection("sayings")
            let key = subm.document().documentID
            
            print("[ rand key ] \(key)")
            
            subm.whereField("__name__", isGreaterThan: key).whereField("explicit", in: self.vulgarContentAllowed ? [true, false] : [false]).limit(to: 1).getDocuments(completion: {
                snapshot, error in
                
                if (snapshot == nil || ((snapshot?.documents.count ?? 0) < 1)) {
                    
                    return self.randomSaying()
                }
                if (snapshot?.documents[0].documentID == self.saying?.name ?? "") {
                    return self.randomSaying()
                }
                (snapshot?.documents ?? []).forEach({
                    DocumentSnapshot in
                    let data = DocumentSnapshot.data()
                    self.saying = Saying(title: data["title"] as? String ?? "", paragraphs: data["paragraphs"] as? [String] ?? [], author: data["author"] as? String ?? "", explicit: data["explicit"] as? Bool ?? true, id: 0, name: DocumentSnapshot.documentID)
                })
            })
        }
        
    //    func nextSaying() {
    //        self.index = (self.index+1)
    //        if (self.index >= self.meta.highestId) {
    //            self.index = 0
    //        }
    //        fetchSaying()
    //    }
    //
    //    func prevSaying() {
    //        self.index = (self.index-1)
    //        if (self.index <= -1) {
    //            self.index = self.meta.highestId-1
    //        }
    //        fetchSaying(fwd: false)
    //    }
        
        func addSubmission(submission: Submission) {
            let db = Firestore.firestore()
                
            _ = db.collection("submissions").addDocument(data: ["author": submission.name, "title": submission.title, "content": submission.content, "email": submission.email])
                
            }
    }

