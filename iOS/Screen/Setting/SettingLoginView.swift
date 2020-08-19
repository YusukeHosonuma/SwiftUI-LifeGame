//
//  SettingLoginView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import AuthenticationServices
import SwiftUI
import os
import FirebaseAuth
import CryptoKit

private let logger = Logger(subsystem: "LifeGameApp", category: "SettingLoginView")

struct SettingLoginView: View {
    @EnvironmentObject var authentication: Authentication

    @Binding private var isPresented: Bool
    @State private var isPresentedLoginFailedAlert = false
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentNonce: String?

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("You can use personal feature.").bold()
                    Group {
                        Label("Favorite", systemImage: "checkmark.circle.fill")
                        Label("Selected history", systemImage: "checkmark.circle.fill")
                    }
                    .foregroundColor(.secondary)
                }
                .font(.title3)
                .padding([.bottom], 100)
                
                SignInWithAppleButton(.signIn, onRequest: onRequest, onCompletion: onCompletion)
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(width: 280, height: 44)
                    .padding()
                    .alert(isPresented: $isPresentedLoginFailedAlert) {
                        Alert(title: Text("Login is failed."))
                    }
            }
            .navigationTitle("Sign-in")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }
    }
    
    // MARK: Actions
    
    private func dismiss() {
        isPresented = false
    }
    
    // MARK: Private
    
    private func onRequest(request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        // Note:
        // とりあえず今は何も取得しない。
        // request.requestedScopes = [.fullName, .email]
    }
    
    private func onCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case let .success(authorization):
            self.signIn(authorization: authorization)
            
        case let .failure(error):
            logger.notice("Sign in with Apple is failed. - \(error.localizedDescription)")
        }
    }
    
    private func signIn(authorization: ASAuthorization) {
        // TODO: エラー処理は細かく精査してないので、とりあえず`fatalError`にして失敗した時にすぐに気付けるようにしておく。
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            fatalError()
        }
        
        guard let nonce = currentNonce else {
            logger.fault("Invalid state: A login callback was received, but no login request was sent.")
            fatalError()
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            logger.error("Unable to fetch identity token")
            fatalError()
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            logger.error("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            fatalError()
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error as NSError? {
                logger.error("Firebase sign-in is failure. - \(error.localizedDescription)")
                isPresentedLoginFailedAlert.toggle()
            }
            isPresented = false
        }
    }
}

struct SettingLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLoginView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.dark)
            .preferredColorScheme(.dark)

        SettingLoginView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.light)
            .preferredColorScheme(.light)

        SettingLoginView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: true))
            .colorScheme(.light)
            .preferredColorScheme(.light)
    }
}

// MARK: - Functions

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
