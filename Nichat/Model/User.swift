//
//  User.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let username: String
    var keywordsForSearch: [String] {
        username.prefixes()
    }
}
