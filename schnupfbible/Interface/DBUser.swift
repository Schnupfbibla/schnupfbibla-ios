//
//  DBUser.swift
//  schnupfbible
//
//  Created by Jesse Born on 25.01.23.
//

import Foundation

struct DBUser {
    var uid: String;
    var anon: Bool;
    var likedSayings: [String]
    
    var email: String?;
    var displayName: String?;
}
