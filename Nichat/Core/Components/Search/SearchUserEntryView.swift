//
//  SearchUserEntryView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct SearchUserEntryView: View {
    let user: User
    
    var body: some View {
        HStack {
            Text("@" + user.username)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "arrow.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(GlobalConstants.primaryColor)
        .cornerRadius(GlobalConstants.cornerRadius)
        .padding(.horizontal)
    }
}

struct SearchUserEntryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserEntryView(user: User(id: "1", username: "nichke"))
    }
}
