//
//  SettingRootView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

struct SettingRootView: View {
    @EnvironmentObject var authentication: Authentication

    @State private var isPresentedLogin = false
    @State private var isPresentedConfirmLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: SettingAboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                }
                Section {
                    NavigationLink(destination: SettingConfigView()) {
                        Label("Game Config", systemImage: "gearshape")
                    }
                }
                Section(footer: Text("You can use some personal feature when login.")) {
                    HCenter {
                        if authentication.isSignIn {
                            Button("Sign-out", action: { isPresentedConfirmLogoutAlert.toggle() })
                                .alert(isPresented: $isPresentedConfirmLogoutAlert, content: logoutConfirmAlert)
                        } else {
                            Button("Login") {
                                isPresentedLogin.toggle()
                            }
                            .sheet(isPresented: $isPresentedLogin) {
                                SignInView(isPresented: $isPresentedLogin)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle()) // Note: 明示的に指定しないと iPad でサイドバー表示になってしまう
            .navigationTitle("Settings")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func logoutConfirmAlert() -> Alert {
        Alert(title: Text("Are you Sign-out?"),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text("Sign out")) { authentication.signOut() })
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.dark)
            .preferredColorScheme(.dark)

        SettingRootView()
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.light)
            .preferredColorScheme(.light)
    }
}
