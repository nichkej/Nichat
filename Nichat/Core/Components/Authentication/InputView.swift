//
//  InputView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct InputView: View {
    let placeholder: String
    @Binding var text: String
    var isSecureField = false
    
    var body: some View {
        CustomTextFieldView(placeholder: Text(placeholder), text: $text, isSecureField: isSecureField)
            .padding(.horizontal)
            .padding(.vertical, AuthenticationConstants.inputPaddingInnerVertical)
            .background(AuthenticationConstants.inputColorBackground)
            .cornerRadius(GlobalConstants.cornerRadius)
            .padding(.horizontal, AuthenticationConstants.inputPaddingOuterHorizontal)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(placeholder: "This is a test inputView", text: .constant(""))
    }
}
