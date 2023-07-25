//
//  SignUpView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var channelManager: ChannelManager
    @EnvironmentObject var messageManager: MessageManager
    
    var body: some View {
        ZStack {
            GlobalConstants
                .backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: AuthenticationConstants.fieldSpacingVertical) {
                Spacer()
                        
                Text("Register for Nichat")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.vertical)
                
                // registration input section
                
                InputView(placeholder: "Enter your email address", text: $email)
                InputView(placeholder: "Create your username", text: $username)
                InputView(placeholder: "Create your password", text: $password, isSecureField: true)
                InputView(placeholder: "Confirm your password", text: $confirmPassword, isSecureField: true)
                
                Button {
                    Task {
                        try await authManager.createUser(withEmail:email, password: password, username: username)
                        if let user = authManager.currentUser {
                            try await channelManager.fetchChannels(for: user.username)
                            for channel in channelManager.channels {
                                messageManager.getMessages(from: channel.name)
                            }
                        }
                    }
                } label: {
                    ButtonView(text: "SIGN UP")
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                Spacer()
                                
                // login call for action
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: AuthenticationConstants.alternativeButtonSpacingHorizontal) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                }
            }
        }
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && username.isValidUsername()
        && !password.isEmpty
        && password.count > 5
        && password == confirmPassword
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthManager())
            .environmentObject(ChannelManager())
            .environmentObject(MessageManager())
    }
}
