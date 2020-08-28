//
//  MacNavigationView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/23.
//

import SwiftUI

struct MacSidebar: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var authentication: Authentication

    @Environment(\.colorScheme) private var colorScheme

    @State private var isPresentedLoginFailedAlert = false
    @State private var isSignInProgress = false
    
    var body: some View {
        List {
            Section(header: Text("Presets")) {
                Text("Random")
                    .onTapGesture(perform: gameManager.generateRandom)
            }

            Section(header: Text("Animation Speed")) {
                Slider(value: $gameManager.speed, in: 0...1, onEditingChanged: gameManager.speedChanged)
            }
            
            Section(header: Text("Sign-in")) {
                HCenter {
                    if authentication.isSignIn {
                        Button("Logout") {
                            authentication.signOut()
                        }
                    } else {
                        if isSignInProgress {
                            ProgressView()
                        } else {
                            SignInButton(inProgress: $isSignInProgress, completion: signInCompletion)
                                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                                .frame(height: 36)
                                .padding()
                                .alert(isPresented: $isPresentedLoginFailedAlert) {
                                    Alert(title: Text("Login is failed."))
                                }
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 212, idealWidth: 212, maxWidth: 212, maxHeight: .infinity)
    }
    
    // MARK: Private
    
    private func signInCompletion(error: Error?) -> Void {
        if let _ = error {
            isPresentedLoginFailedAlert.toggle()
        }
    }
}

//struct MacNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        MacNavigationView()
//    }
//}
