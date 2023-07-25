//
//  ChatListView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    
    var body: some View {
        NavigationStack(path: $channelManager.activeChannel) {
            ZStack {
                GlobalConstants
                    .backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    
                    // sign out button
                    
                    Button {
                        viewModel.signOut()
                    } label: {
                        Text("Sign out")
                    }
                    
                    // channel list for authManager.currentUser
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(channelManager.channels, id: \.id) { channel in
                                NavigationLink(value: channel.name) {
                                    ChannelEntryView(channelName: channel.name)
                                }
                            }
                        }
                    }
                }
                .padding(.top, GlobalConstants.viewPaddingTop)
            }
            .navigationDestination(for: String.self) { channelName in
                ChannelView(channelName: channelName)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .accentColor(.black)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environmentObject(ViewModel())
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
    }
}
