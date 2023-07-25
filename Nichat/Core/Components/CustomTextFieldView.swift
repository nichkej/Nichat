//
//  CustomTextFieldView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct CustomTextFieldView: View {
    let placeholder: Text
    @Binding var text: String
    var isSecureField = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            if !isSecureField {
                TextField("", text: $text, onEditingChanged: {_ in }, onCommit: {})
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.oneTimeCode)
            } else {
                SecureField("", text: $text)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.oneTimeCode)
            }
        }
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(placeholder: Text("This is a test custom text field"), text: .constant(""))
    }
}

