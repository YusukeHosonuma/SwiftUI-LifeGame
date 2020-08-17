//
//  Authentication.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/16.
//

import FirebaseAuth

final class Authentication: ObservableObject {
    
    static var shared = Authentication()
    
    @Published var isSignIn: Bool = false
    @Published var user: User?
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.isSignIn = true
            } else {
                self.user = nil
                self.isSignIn = false
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}
