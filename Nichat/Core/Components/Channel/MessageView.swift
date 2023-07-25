//
//  MessageView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct MessageView: View {
    let message: Message
    @Binding var scrollTarget: String?
    
    @Binding var quotedId: String
    @Binding var quotedAuthor: String
    @Binding var quotedContent: String
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var messageManager: MessageManager
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                
                // quoted message appears above main content
                
                if message.quotedId != "" {
                    ZStack {
                        Rectangle()
                            .foregroundColor(GlobalConstants.accentColor)
                        
                        (Text("@\(message.quotedAuthor): ")
                            .fontWeight(.semibold)
                         + Text(message.quotedContent)
                            .fontWeight(.medium))
                        .font(.subheadline)
                        .padding()
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .onTapGesture {
                        scrollTarget = message.quotedId
                    }
                }
                
                // main message content
                
                ZStack {
                    Rectangle()
                        .foregroundColor(GlobalConstants.primaryColor)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        (Text("@\(message.author): ")
                            .fontWeight(.bold)
                         + Text(message.content)
                            .fontWeight(.semibold))
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.top)
                        Text("\(message.date.formatted(.dateTime.hour().minute()))")
                            .font(.footnote)
                            .padding(.leading, 20)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onTapGesture { }
                .onLongPressGesture {
                    quotedId = message.id
                    quotedAuthor = message.author
                    quotedContent = message.content
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .cornerRadius(GlobalConstants.cornerRadius)
            
            // like button (allow if it's not a bot message
            // make message unlikable for its sender
            // indicate that current user liked a message by using primarycolor
            // otherwise use accentcolor
            
            if message.author != authManager.currentUser?.username && message.author != "nichatBot" {
                Button {
                    messageManager.setLikeStatus(to: !message.likeStatus, in: channelManager.activeChannel[0], for: message)
                } label: {
                    if message.likeStatus {
                        Image(systemName: "heart.fill")
                            .imageScale(.large)
                            .foregroundColor(GlobalConstants.primaryColor)
                            .padding(.vertical)

                    } else {
                        Image(systemName: "heart")
                            .imageScale(.large)
                            .foregroundColor(GlobalConstants.primaryColor)
                            .padding(.vertical)

                    }
                }
            } else if message.author == authManager.currentUser?.username {
                if message.likeStatus {
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundColor(GlobalConstants.accentColor)
                        .padding(.vertical)
                }
            }
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(id: "1", author: "test-user", content: "Test message", quotedId: "1", quotedAuthor: "quoted", quotedContent: "Quoted", likeStatus: true, date: Date.now), scrollTarget: .constant(""), quotedId: .constant(""), quotedAuthor: .constant(""), quotedContent: .constant(""))
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
            .environmentObject(MessageManager())
    }
}
