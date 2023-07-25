//
//  SearchManager.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class SearchManager: ObservableObject {
    @Published var queriedUsers : [User] = []
        
    func fetchUsers(from keyword: String) async {
        guard let snapshot = try? await Firestore.firestore().collection("users").whereField("keywordsForSearch", arrayContains: keyword).getDocuments() else { return }
        self.queriedUsers = snapshot.documents.compactMap { queryDocumentSnapshot in
            try? queryDocumentSnapshot.data(as: User.self)
        }
    }
}
