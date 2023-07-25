//
//  SearchBarView.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchQuery: String
    
    var body: some View {
        CustomTextFieldView(placeholder: Text("Search for users"), text: $searchQuery)
            .padding(.horizontal)
            .padding(.vertical, SearchConstants.searchBarPaddingVertical)
            .background(GlobalConstants.primaryColor)
            .cornerRadius(GlobalConstants.cornerRadius)
            .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchQuery: .constant(""))
    }
}
