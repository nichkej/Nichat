//
//  NichatApp.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI
import Firebase

@main
struct NichatApp: App {
    @StateObject var viewModel = ViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(viewModel.authManager)
                .environmentObject(viewModel.channelManger)
                .environmentObject(viewModel.messageManager)
                .environmentObject(viewModel.searchManager)
        }
    }
}
