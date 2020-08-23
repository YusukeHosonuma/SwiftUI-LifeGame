//
//  SettingLoginView.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/18.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authentication: Authentication

    @Binding private var isPresented: Bool
    @State private var isPresentedLoginFailedAlert = false
    @State private var isDisplayProgress = false
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentNonce: String?

    var body: some View {
        NavigationView {
            ZStack {
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
                    
                    SignInButton(inProgress: $isDisplayProgress, completion: signInCompletion)
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 280, height: 44)
                        .padding()
                        .alert(isPresented: $isPresentedLoginFailedAlert) {
                            Alert(title: Text("Login is failed."))
                        }
                }
                .navigationTitle("Sign-in")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss)
                    }
                }
                
                if isDisplayProgress {
                    ProgressView("Sign-in")
                }
            }
        }
    }
    
    private func signInCompletion(error: Error?) -> Void {
        if let _ = error {
            isPresentedLoginFailedAlert.toggle()
        } else {
            isPresented = false
        }
    }
    
    // MARK: Actions
    
    private func dismiss() {
        isPresented = false
    }
}

struct SettingLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.dark)
            .preferredColorScheme(.dark)

        SignInView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: false))
            .colorScheme(.light)
            .preferredColorScheme(.light)

        SignInView(isPresented: .constant(true))
            .environmentObject(Authentication(mockSignIn: true))
            .colorScheme(.light)
            .preferredColorScheme(.light)
    }
}
