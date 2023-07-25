//
//  LoginView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var messageManager: MessageManager

    var body: some View {
        NavigationStack {
            ZStack {
                GlobalConstants
                    .backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: AuthenticationConstants.fieldSpacingVertical) {
                    Spacer()
                    
                    Text("Welcome to Nichat")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.vertical)
                    
                    // login input section
                    
                    InputView(placeholder: "Enter your email address", text: $email)
                    InputView(placeholder: "Enter your password", text: $password, isSecureField: true)
                    
                    Button {
                        Task {
                            try await authManager.signIn(withEmail: email, password: password)
                            if let user = authManager.currentUser {
                                try await channelManager.fetchChannels(for: user.username)
                                for channel in channelManager.channels {
                                    messageManager.getMessages(from: channel.name)
                                }
                            }
                        }
                    } label: {
                        ButtonView(text: "SIGN IN")
                    }
                    
                    Spacer()
                    
                    // registration call for action
                                    
                    NavigationLink {
                        SignUpView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: AuthenticationConstants.alternativeButtonSpacingHorizontal) {
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
            .environmentObject(MessageManager())
    }
}
