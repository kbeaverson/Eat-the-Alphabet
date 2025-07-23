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
    @State var restaurants: [Restaurant] = []
    @State var friends: [Friends] = []
    @State var challenges: [Challenge] = []
    
    var accountRepository = AccountRepository()
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.9
            BackgroundScaffold {
                VStack(spacing: 20) {
                    HStack{
                        // TODO: Convert this to user bar with name, profile picture
                        var greeting: String = "Hello, \(account?.username ?? "User")"
                        Text(greeting)
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .truncationMode(.tail)
                            .accessibilityLabel("Greeting to user: \(greeting)")
                        Spacer()
                        Button("Logout") {
                            // Handle logout action
                            print("Logout tapped")
                            logOut()
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing, 20)
                        .foregroundColor(.defaultText)
                        .accessibilityLabel("Logout Button")
                    }
                    .padding(.horizontal, 20)
                    
                    // User stats, future: badges/achievements
                    GroupBox {
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("\(friends.count)")
                            Image(systemName: "fork.knife")
                            Text("\(challenges.count)")
                            Spacer()
                        }
                    }.frame(width: fieldWidth, height: 20)
                    .accessibilityLabel("User stats display. Number of friends: \(friends.count), challenges: \(challenges.count)")
                    
                    ScrollView {
                        // Pie chart with types of cuisines user has visited
                        GroupBox ("Cuisines Visited"){
                            Chart {
                                let cuisineCounts = Dictionary(grouping: restaurants) { $0.cuisine }
                                    .mapValues{ $0.count }
                                ForEach(Array(cuisineCounts), id: \.key) { cuisine, count in
                                    SectorMark(
                                        angle: .value("Count", count),
                                        innerRadius: .ratio(0.618),
                                        outerRadius: .ratio(1.0),
                                        angularInset: 1.0,
                                    ).foregroundStyle(by: .value("Cuisine", cuisine))
                                        .cornerRadius(4)
                                    .accessibilityLabel("Pie chart sector for \(cuisine) cuisine. Number of restaurants visited: \(count)")
                                }
                            }
                        }
                        .frame(width: fieldWidth, height: 200)
                        .chartLegend(.visible)
                        .accessibilityLabel("Pie chart displaying the types of cuisines the user has visited.")
                        // Bar chart with ratings of restaurants given
                        GroupBox("Restaurant Ratings") {
                            Chart {
                                let ratingCounts = Dictionary(grouping: reviews) { $0.rating }
                                    .mapValues { $0.count }
                                    .sorted { $0.key < $1.key }
                                ForEach(ratingCounts, id: \.key) { rating, count in
                                    BarMark(
                                        x: .value("Rating", rating),
                                        y: .value("Count", count)
                                    )
                                    .accessibilityLabel("Bar for rating \(rating). Number of restaurants visited: \(count)")
                                }
                            }.chartXAxis {
                                AxisMarks(values: [1, 2, 3, 4, 5])
                            }
                        }.frame(width: fieldWidth, height: 200)
                        .accessibilityLabel("Bar chart displaying the average rating of restaurants the user has visited.")
                        // Line chart with amount of experiences by month
                        GroupBox("Experiences by Day") {
                            Chart {
                                let calendar = Calendar.current
                                
                                let dailyCounts = Dictionary(grouping: experiences) { experience in
                                    calendar.startOfDay(for: experience.created_at)
                                }
                                    .mapValues { $0.count }
                                    .sorted { $0.key < $1.key}
                                ForEach (dailyCounts, id: \.key) { date, count in
                                    LineMark(
                                        x: .value("Date", date),
                                        y: .value("Count", count)
                                    )
                                    .accessibilityLabel("Point for date \(date). Number of experiences: \(count)")
                                }
                            }.chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: 7)) { value in
                                    AxisGridLine()
                                    AxisValueLabel(format: .dateTime.day().month())
                                }
                            }
                        }.frame(width: fieldWidth, height: 200)
                            .accessibilityLabel("Line chart displaying the number of experiences the user has had each day.")
                    }
                }
                // makes the VStack fill its parent vertically, and pins its contents to the top
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)

            }
        }.onAppear {
            print("Account view appeared")
            loadFriends()
            loadChallenges()
            loadExperiences()
            loadReviews()
            loadRestaurants()
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
                let fetchedExperiences = try await accountRepository.fetchAllExperiences(for: account.id)
                await MainActor.run {
                    experiences = fetchedExperiences
                    print("Loaded experiences: \(experiences.count)")
                }
            } catch {
                print("Error loading experiences: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadRestaurants() {
        Task {
            do {
                guard let account = account else {
                    print("No valid account available to load restaurants for")
                    return
                }
                let fetchedRestaurants = try await accountRepository.fetchAllRestaurants(for: account.id)
                await MainActor.run {
                    restaurants = fetchedRestaurants
                    print("Loaded restaurants: \(restaurants.count)")
                }
            } catch {
                print("Error loading restaurants: \(error.localizedDescription)")
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
                let fetchedReviews = try await accountRepository.fetchReviews(for: account.id) ?? []
                await MainActor.run {
                    reviews = fetchedReviews
                    print("Loaded reviews: \(reviews.count)")
                }
            } catch {
                print("Error loading reviews: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadFriends() {
        Task {
            do {
                guard let account = account else {
                    print("No valid account available to load friends")
                    return
                }
                let fetchedFriends = try await accountRepository.fetchFriends(of: account.id)
                await MainActor.run {
                    friends = fetchedFriends
                    print("Loaded friends: \(friends.count)")
                }
            } catch {
                print("Error loading friends: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadChallenges() {
        Task {
            do {
                guard let account = account else {
                    print("No valid account available to load challenges")
                    return
                }
                let fetchedChallenges = try await accountRepository.fetchChallenges(for: account.id) ?? []
                await MainActor.run {
                    challenges = fetchedChallenges
                    print("Loaded challenges: \(challenges.count)")
                }
            } catch {
                print("Error loading challenges: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AccountView(session: .constant(nil), account: .constant(nil))
}
