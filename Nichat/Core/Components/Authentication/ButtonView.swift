//
//  ButtonView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct ButtonView: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
            Image(systemName: "arrow.right")
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(AuthenticationConstants.buttonColorForeground)
        .padding()
        .background(AuthenticationConstants.buttonColorBackground)
        .cornerRadius(GlobalConstants.cornerRadius)
        .padding(.horizontal, AuthenticationConstants.buttonPaddingHorizontal)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Button")
    }
}
