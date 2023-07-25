//
//  SearchView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct SearchView: View {
    @Binding var selection: String
    @State var searchQuery = ""
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var searchManager: SearchManager
    
    var body: some View {
        // use a custom setter to allow real-time user fetching when searching
        let searchQueryBinding = Binding<String>(
            get: {
                searchQuery
            },
            set: {
                searchQuery = $0
                Task {
                    await searchManager.fetchUsers(from: searchQuery)
                }
            }
        )
        
        ZStack {
            GlobalConstants
                .backgroundColor
                .ignoresSafeArea()
            
            VStack {
                
                // searchbar view
                
                SearchBarView(searchQuery: searchQueryBinding)
                
                // fetched users list view
                
                ScrollView {
                    LazyVStack(spacing: SearchConstants.searchResultSpacingVertical) {
                        ForEach(searchManager.queriedUsers, id: \.id) { user in
                            Button {
                                Task {
                                    try await channelManager.createChannel(for: authManager.currentUser!, and: user)
                                    if !channelManager.isPresentedAlertSingleUserChannel {
                                        selection = "chat"
                                    }
                                }
                            } label: {
                                SearchUserEntryView(user: user)
                            }
                        }
                    }
                    .alert(isPresented: $channelManager.isPresentedAlertSingleUserChannel) {
                        Alert(title: Text("Error creating chat!"), message: Text("You can't create chat with yourself!"))
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selection: .constant(""))
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
            .environmentObject(SearchManager())
    }
}
