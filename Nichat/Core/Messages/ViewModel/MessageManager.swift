//
//  MessageManager.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessageManager: ObservableObject {
    @Published var messages: Dictionary<String, [Message]> = [:]
    @Published var lastMessageId: Dictionary<String, String> = [:]
    // store listeners in an array to allow real-time updates and listener removal upon signing out
    // each channel a user is involved in should contain an active listener
    var listeners: [ListenerRegistration] = []
    
    func getMessages(from channel: String) {
        guard messages[channel] == nil else { return }
        self.messages[channel] = []
        listeners.append(
            Firestore.firestore().collection(channel).addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                self.messages[channel] = documents.compactMap { document -> Message? in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Error decoding document into Message: \(error)")
                        return nil
                    }
                }
                // sort channels by latest message received
                self.messages[channel] = self.messages[channel]?.sorted {
                    $0.date < $1.date
                }
                if let id = self.messages[channel]?.last?.id {
                    self.lastMessageId[channel] = id
                }
            }
        )
    }
    
    func sendMessage(to channel: String, author: String, content: String, quotedId: String, quotedAuthor: String, quotedContent: String) {
        do {
            let newMessage = Message(id: "\(UUID().uuidString)", author: author, content: content, quotedId: quotedId, quotedAuthor: quotedAuthor, quotedContent: quotedContent, likeStatus: false, date: Date.now)
            try Firestore.firestore().collection(channel).document(newMessage.id).setData(from: newMessage)
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    func setLikeStatus(to value: Bool, in channel: String, for message: Message) {
        Firestore.firestore().collection(channel).document(message.id).updateData(["likeStatus": value])
    }
}
