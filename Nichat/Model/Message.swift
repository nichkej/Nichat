//
//  Message.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let author: String
    let content: String
    let quotedId: String
    let quotedAuthor: String
    let quotedContent: String
    let likeStatus: Bool
    let date: Date
}
