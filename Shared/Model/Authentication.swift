//
//  Authentication.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseAuth

struct AuthenticationRepositories {
    let history: FirestoreHistoryRepository
    let stared: FirestoreStaredRepository
}

final class Authentication: ObservableObject {
    
    static let shared = Authentication()
    
    @Published var isSignIn: Bool = false
    @Published var user: User? // TODO: 独自の型に変更したい
    @Published var repositories: AuthenticationRepositories?
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.isSignIn = true
                self.repositories = AuthenticationRepositories(
                    history: FirestoreHistoryRepository(user: user),
                    stared: FirestoreStaredRepository(user: user)
                )
            } else {
                self.user = nil
                self.isSignIn = false
                self.repositories = nil
            }
        }
    }
    
    #if DEBUG
    init(mockSignIn: Bool) { // TODO: とりあえずやっつけ
        isSignIn = mockSignIn
    }
    #endif
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}
