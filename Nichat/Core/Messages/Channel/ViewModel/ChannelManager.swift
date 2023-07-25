//
//  ChannelManager.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ChannelManager: ObservableObject {
    // activeChannel doesn't indicate a channel nor does it indicate an array of channels
    // it is kept an array to ensure proper communciation of path to NavigationStack when needed
    // useful when directly redirecting user to chat view from search view
    // this also prevents need for String? value when user isn't viewing any specific channel
    // so ["user1_user2"] indicates the path of navigation stack should point to user1_user2
    @Published var activeChannel: [String] = []
    @Published var channels: [Channel] = []
    @Published var isPresentedAlertSingleUserChannel = false
    
    var activeListener: ListenerRegistration? = nil
    
    func channelName(for firstUser: User, and secondUser: User) -> String {
        // combine usernames in lexicographically increasing order separated by '_'
        var firstUsername = firstUser.username
        var secondUsername = secondUser.username
        if firstUsername > secondUsername {
            let tmp = firstUsername
            firstUsername = secondUsername
            secondUsername = tmp
        }
        let channelName = firstUsername + "_" + secondUsername
        return channelName
    }
    
    func channelExists(for firstUser: User, and secondUser: User) async throws -> Bool {
        do {
            let exists = try await !Firestore.firestore().collection(channelName(for: firstUser, and: secondUser)).limit(to: 1).getDocuments().isEmpty
            return exists
        } catch {
            print("DEBUG: Error checking wheteher a channel for \(firstUser) and \(secondUser) exists: \(error.localizedDescription)")
            return true
        }
    }
    
    func fetchChannels(for username: String) async throws {
        // activeListener needs to be changed each time we enter the app to prevent non-related channels appearing in user's channel list
        // keep it in a variable to be able to remove listener upong signing out
        activeListener = Firestore.firestore().collection("channels_" + username).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.channels = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Channel.self)
            }
            self.channels.sort(by: {
                $0.lastMessageTime > $1.lastMessageTime
            })
        }
    }
    
    func updateChannel(_ channel: String, for user: String, with message: String, at date: Date) async {
        do {
            try await Firestore.firestore().collection("channels_" + user).document(channel).updateData(["lastMessage": message, "lastMessageTime": date])
        } catch {
            print("DEBUG: Error updating channel \(channel) for user \(user): \(error.localizedDescription)")
        }
    }
     
    func createChannel(for firstUser: User, and secondUser: User) async throws {
        guard firstUser != secondUser else {
            print("DEBUG: Error creating a channel for \(firstUser) and \(secondUser): Can't create a chat for a single user")
            isPresentedAlertSingleUserChannel = true
            return
        }
        guard try await !channelExists(for: firstUser, and: secondUser) else {
            print("Channel for \(firstUser) and \(secondUser) already exists.")
            activeChannel = [channelName(for: firstUser, and: secondUser)]
            return
        }
        do {
            var firstUsername = firstUser.username
            var secondUsername = secondUser.username
            if firstUsername > secondUsername {
                let tmp = firstUsername
                firstUsername = secondUsername
                secondUsername = tmp
            }
            let channelName = firstUsername + "_" + secondUsername
            // a collection in firestore cannot be empty, thus enter a greeting message
            // this message however should be treated as special message later in implementation (e. g. no like ability)
            let greetingMessage = Message(id: UUID().uuidString, author: "nichatBot", content: "This is the start of a conversation between \("@" + firstUsername) and \("@" + secondUsername)", quotedId: "", quotedAuthor: "", quotedContent: "", likeStatus: false, date: Date.now)
            let encodedGreetingMessage = try Firestore.Encoder().encode(greetingMessage)
            try await Firestore.firestore().collection(channelName).document(greetingMessage.id).setData(encodedGreetingMessage)
            let channel = Channel(id: UUID().uuidString, name: channelName, lastMessage: greetingMessage.content, lastMessageTime: greetingMessage.date)
            let encodedChannel = try Firestore.Encoder().encode(channel)
            try await Firestore.firestore().collection("channels_" + firstUsername).document(channel.name).setData(encodedChannel)
            try await Firestore.firestore().collection("channels_" + secondUsername).document(channel.name).setData(encodedChannel)
            activeChannel = [channelName]
        } catch {
            print("DEBUG: Error creating a channel for \(firstUser) and \(secondUser): \(error.localizedDescription)")
        }
    }
}
