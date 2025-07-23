//
//  ExperienceListItem.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/4.


import SwiftUI
import UIKit

// the class is to embedded with a restaurantListItem, as a Restaurant is a part of an Experience
struct ExperienceListItem: View {
    // PASSED-IN experience
    var experience: Experience
    
    @StateObject private var viewModel: ExperienceViewModel = ExperienceViewModel()
    
    @Binding var isSelected: Bool // THIS now is part of the outer view
    var isSelectionModeOn: Bool = false // THIS now is part of the outer view
    var onTap: (() -> Void)? = nil // for tap handling
    
    @State private var isParticipated: Bool? = nil // Track if the user has participated
    
    var body: some View {
        NavigationLink( destination: ExperienceDetailsView(
            experience: viewModel.experience ?? experience,
        )){
            VStack(alignment: .leading) {
                HStack() {
                    // the experience title
                    Text("Experience of \(viewModel.experience?.letter ?? "Unknown Letter")")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                        .padding(3)
                        .background(.clear)
                    Spacer()
                    // checkbox if in selection mode
                    if (isSelectionModeOn) {
                        Toggle("", isOn: $isSelected)
                            .toggleStyle(CheckboxToggleStyle())
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 12)
                    }
                }
                
                
                // if the associated restaurant is loaded, show it
                if let restaurant = viewModel.experience?.restaurant {
                    RestaurantListItem(
                        restaurant: restaurant
                    )
                }
            }
            .padding(8)
            .onAppear {
                viewModel.experience = experience
                if let restaurant = experience.restaurant {
                    viewModel.experience?.restaurant = restaurant
                    print("Using passed-in restaurant: \(restaurant)")
                } else {
                    print("Need to load restaurant async...")
                    Task {
                        await viewModel.loadAssociatedRestaurant()
                    }
                }
                
                // check if the user has participated in this experience
                Task {
                    do {
                        let participated = try await viewModel.checkParticipation(experienceId: experience.id)
                        isParticipated = participated
                        print("ExperienceListItem: User has participated: \(participated)")
                    } catch {
                        print("Error checking participation: \(error)")
                        isParticipated = false
                        throw error
                    }
                }
            }
            .background(.white.opacity((isParticipated ?? false) ? 0.6 : 0.15))
            .cornerRadius(12)
            // long-press to show additional information
            .contextMenu {
                // options: join if not joined, leave if joined
                if let isParticipated = isParticipated {
                    Button(action: {
                        Task {
                            if isParticipated {
                                do {
                                    try await viewModel.leaveExperience(experienceId: experience.id)
                                    await MainActor.run {
                                        self.isParticipated = false
                                    }
                                } catch {
                                    print("Error leaving experience: \(error.localizedDescription)")
                                }
                            } else {
                                do {
                                    try await viewModel.joinExperience(experienceId: experience.id)
                                    await MainActor.run {
                                        self.isParticipated = true
                                    }
                                } catch {
                                    print("Error joining experience: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        if isParticipated {
                            Label("Leave Experience", systemImage: "trash")
                                .foregroundStyle(.red)
                        } else {
                            Label("Join Experience", systemImage: "plus")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
    }
}
