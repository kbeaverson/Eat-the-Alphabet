//
//  RegisterView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/4.
//

import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    Text("Register")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
                    
                    TextField("Username", text: $username)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("Email/Phone Address", text: $email)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    SecureField("Password", text: $password)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    SecureField("Confirm password", text: $confirmPassword)
                        .padding(12) // inner padding (inside white box)
                        .background(.textFieldBg)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    Toggle("I agree to the Terms and Conditions.", isOn: $agreedToTerms)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    Button(action: {
                        print("Register tapped")
                        // check if agreed to terms
                        if (!agreedToTerms) {
                            alertMessage = "You must agree to the terms and conditions."
                            showAlert = true
                            return
                        }
                        // check if passwords match
                        if password != confirmPassword {
                            alertMessage = "Passwords do not match."
                            showAlert = true
                            return
                        }
                        
                        AuthService.shared.register(
                            username: username,
                            email: email,
                            password: password
                        ) { result in
                            switch result {
                            case .success(let user):
                                print("Registered ")
                                // DO NOT Navigate to the main app view or show success message
                            case .failure(let error):
                                print("Registration error: \(error.localizedDescription)")
                                alertMessage = "Registration failed: \(error.localizedDescription)"
                                showAlert = true
                            }
                        }
                        
                    }) {
                        Text("Register")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .frame(width: buttonWidth, height: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.buttonBg)
                            )
                            .foregroundStyle(.white)
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding(.horizontal, 40)
                .onAppear { print("RegisterView appeared") }
                .onDisappear{ print("RegisterView disappeared") }
            }
        }
    }
}
