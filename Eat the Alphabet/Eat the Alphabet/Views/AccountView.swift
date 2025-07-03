//
//  AccountView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import Supabase

struct AccountView: View {
    @Binding var session: Session?
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    HStack{
                        Text("Account")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 40)
                        Spacer()
                        Button("Logout") {
                            // Handle logout action
                            print("Logout tapped")
                            logOut()
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing, 20)
                        .foregroundColor(.defaultText)
                    }
                    .padding(.horizontal, 20)
                    
                    // Placeholder for account details
                    
                    Text("Account View")
                }
                // makes the VStack fill its parent vertically, and pins its contents to the top
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)

            }
        }
    }
    private func logOut() {
        Task {
            do {
                // get the current session first
                try await supabaseClient.auth.signOut()
                // reset the session
                session = nil
            } catch {
                print("Failed to log out: \(error.localizedDescription)")
            }
        }
        
    }
}

#Preview {
    AccountView(session: .constant(nil))
}
