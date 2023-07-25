//
//  MessageSubmitView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct MessageSubmitView: View {
    @State private var message = ""
    
    @Binding var quotedId: String
    @Binding var quotedAuthor: String
    @Binding var quotedContent: String
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var messageManager: MessageManager
    
    var body: some View {
        HStack {
            CustomTextFieldView(placeholder: Text("Enter your message here"), text: $message)
            Button {
                if let user = authManager.currentUser {
                    messageManager.sendMessage(to: channelManager.activeChannel[0], author: user.username, content: message, quotedId: quotedId, quotedAuthor: quotedAuthor, quotedContent: quotedContent)
                    
                    let channelName = channelManager.activeChannel[0]
                    let usersToUpdate = channelName.components(separatedBy: "_")
                        
                    Task {
                        await channelManager.updateChannel(channelName, for: usersToUpdate[0], with: message, at: Date.now)
                        await channelManager.updateChannel(channelName, for: usersToUpdate[1], with: message, at: Date.now)
                    }
                    
                    quotedId = ""
                    quotedAuthor = ""
                    quotedContent = ""
                    message = ""
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(ChannelConstants.messageSubmitButtonPadding)
                    .background(GlobalConstants.accentColor)
                    .cornerRadius(ChannelConstants.messageSubmitButtonCornerRadius)
            }
        }
        .padding(.leading)
        .padding(.trailing, ChannelConstants.messageSubmitPaddingTrailing)
        .padding(.vertical, ChannelConstants.messageSubmitPaddingVertical)
        .background(GlobalConstants.primaryColor)
        .cornerRadius(GlobalConstants.cornerRadius)
        .padding()
    }
}

struct MessageSubmitView_Previews: PreviewProvider {
    static var previews: some View {
        MessageSubmitView(quotedId: .constant(""), quotedAuthor: .constant(""), quotedContent: .constant(""))
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
            .environmentObject(MessageManager())
    }
}
