//
//  Channel.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation

struct Channel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let lastMessage: String
    let lastMessageTime: Date
}
