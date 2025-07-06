//
//  AccountView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import Supabase
import Charts

struct AccountView: View {
    @Binding var session: Session?
    @Binding var account: Account?
    
    @State var experiences: [Experience] = []
    @State var reviews: [Review] = []
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    HStack{
                        // TODO: Convert this to user bar with name, profile picture
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
                    } // TODO: Add another hstack with user badges/achievements
                    .padding(.horizontal, 20)
                    
                    // Placeholder for account details
                    
                    Text("Account View")
                    // TODO: Pie chart with types of cuisines user has visited
                    // TODO: Bar chart with ratings of restaurants given
                    Chart {
                        let ratingCounts = Dictionary(grouping: reviews) { $0.rating }
                            .mapValues { $0.count }
                            .sorted { $0.key < $1.key }
                        ForEach(ratingCounts, id: \.key) { rating, count in
                            BarMark(
                                x: .value("Rating", rating),
                                y: .value("Count", count)
                            )
                        }
                    }.chartXAxis {
                        AxisMarks(values: [1, 2, 3, 4, 5])
                    }.chartYAxis {
                        AxisMarks() // FIXME: Is this part needed?
                    }
                    // TODO: Line chart with amount of experiences by month
                }
                // makes the VStack fill its parent vertically, and pins its contents to the top
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)

            }
        }.onAppear {
            print("Account view appeared")
            loadExperiences()
            loadReviews()
        }
        .onDisappear {
            print("Account view disappeared")
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
    
    private func loadExperiences() {
        Task {
            do {
                guard let account = account else {
                    print("No valid account available to load experiences for")
                    return
                }
                try await experiences = AccountRepository.shared.getExperiences(for: account.id)
            } catch {
                print("Error loading experiences: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadReviews() {
        Task {
            do {
                guard let account = account else {
                    print("No valid account available to load reviews for")
                    return
                }
                try await reviews = AccountRepository.shared.getReviews(by: account.id)
            } catch {
                print("Error loading reviews: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AccountView(session: .constant(nil), account: .constant(nil))
}
