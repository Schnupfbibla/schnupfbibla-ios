//
//  Saying.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import Foundation

struct Saying {
    var title: String
    var paragraphs: [String];
    var author: String;
    var explicit: Bool;
    
    var id: Int;
    var name: String;
}

struct Submission {
    var title: String
    var content: String;
    var email: String;
    var name: String;
}
