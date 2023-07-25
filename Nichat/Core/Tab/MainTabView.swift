//
//  MainTabView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab = "chat"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatListView()
                .tabItem {
                    Image(systemName: "paperplane")
                }
                .tag("chat")
            SearchView(selection: $selectedTab)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag("search")
        }
        .accentColor(GlobalConstants.accentColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
