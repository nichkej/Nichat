//
//  ChannelEntryView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct ChannelEntryView: View {
    let channelName: String
    
    var body: some View {
        HStack {
            Text("#" + channelName)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "paperplane")
                .imageScale(.medium)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(GlobalConstants.primaryColor)
        .cornerRadius(GlobalConstants.cornerRadius)
        .padding(.horizontal)
    }
}

struct ChannelEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelEntryView(channelName: "user1-user2")
    }
}
