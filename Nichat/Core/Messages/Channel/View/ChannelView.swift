//
//  ChannelView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct ChannelView: View {
    let channelName: String
    @State var scrollTarget: String?
    
    @State var quotedId = ""
    @State var quotedAuthor = ""
    @State var quotedContent = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var messageManager: MessageManager
    
    var body: some View {
        ZStack {
            GlobalConstants
                .backgroundColor
                .ignoresSafeArea()
            
            VStack() {
                
                // navigation menu
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    Text("#" + channelName)
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .padding(.top)
                .padding(.horizontal)
                
                // message list
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(messageManager.messages[channelName] ?? [], id: \.id) { message in
                                MessageView(
                                    message: message,
                                    scrollTarget: $scrollTarget,
                                    quotedId: $quotedId,
                                    quotedAuthor: $quotedAuthor,
                                    quotedContent: $quotedContent
                                )
                                .id(message.id)
                                .padding(.bottom, ChannelConstants.messageSpacingVertical)
                            }
                        }
                    }
                    .onChange(of: scrollTarget) { target in
                        if let target = target {
                            scrollTarget = nil
                            withAnimation {
                                proxy.scrollTo(target, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: messageManager.lastMessageId[channelName]) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(messageManager.lastMessageId, anchor: .bottom)
                    }
                }
                
                // quoted message popup
                
                if quotedId != "" {
                    Text("@" + quotedAuthor + ": " + quotedContent)
                        .font(.headline)
                        .padding(.horizontal, ChannelConstants.quotedContentPaddingHorizontal)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0.5)
                        .background(GlobalConstants.accentColor)
                        .onTapGesture {
                            quotedId = ""
                            quotedAuthor = ""
                            quotedContent = ""
                        }
                }
                
                // message submit
                
                MessageSubmitView(quotedId: $quotedId, quotedAuthor: $quotedAuthor, quotedContent: $quotedContent)
            }
        }
        .onAppear {
            channelManager.activeChannel = [channelName]
            messageManager.getMessages(from: channelName)
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(channelName: "test-channel")
            .environmentObject(ChannelManager())
            .environmentObject(MessageManager())
    }
}
