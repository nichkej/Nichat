//
//  ViewModel.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation
import FirebaseAuth

@MainActor
class ViewModel: ObservableObject {
    var authManager = AuthManager()
    var channelManger = ChannelManager()
    var messageManager = MessageManager()
    var searchManager = SearchManager()
    
    init() {
        authManager.userSession = Auth.auth().currentUser
        Task {
            // reset all listeners and lists to default values
            await authManager.fetchUser()
            searchManager.queriedUsers = []
            channelManger.activeListener?.remove()
            channelManger.activeListener = nil
            channelManger.channels = []
            channelManger.activeChannel = []
            for index in messageManager.listeners.indices {
                messageManager.listeners[index].remove()
            }
            messageManager.messages = [:]
            messageManager.lastMessageId = [:]
            if let user = authManager.currentUser {
                try await channelManger.fetchChannels(for: user.username)
            }
        }
    }
    
    func signOut() {
        authManager.signOut()
        // reset all listeners and lists to default values
        searchManager.queriedUsers = []
        channelManger.activeListener?.remove()
        channelManger.activeListener = nil
        channelManger.channels = []
        channelManger.activeChannel = []
        for index in messageManager.listeners.indices {
            messageManager.listeners[index].remove()
        }
        messageManager.messages = [:]
        messageManager.lastMessageId = [:]
    }
}
