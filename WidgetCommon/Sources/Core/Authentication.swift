//
//  Authentication.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseAuth

public struct AuthenticationRepositories {
    let history: FirestoreHistoryRepository
    let stared: FirestoreStaredRepository
}

public final class Authentication: ObservableObject {
    
    public static let shared = Authentication()
    
    @Published public var isSignIn: Bool = false
    @Published public var user: User? // TODO: 独自の型に変更したい
    @Published public var repositories: AuthenticationRepositories?
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.repositories = AuthenticationRepositories(
                    history: FirestoreHistoryRepository(user: user),
                    stared: FirestoreStaredRepository(user: user)
                )
                self.isSignIn = true
            } else {
                self.user = nil
                self.repositories = nil
                self.isSignIn = false
            }
        }
    }
    
    #if DEBUG
    public init(mockSignIn: Bool) {
        isSignIn = mockSignIn
    }
    #endif
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}
