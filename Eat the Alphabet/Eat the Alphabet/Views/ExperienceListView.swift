//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//


import SwiftUI
import CoreLocation

struct ExperienceListView: View {
    //    @Environment(\.dismiss) var dismiss // ?
    // @EnvironmentObject var appState: AppState //
    @EnvironmentObject var permissionManager: PermissionManager // Location permission manager
    
    // challenge experience
    let challenge: Challenge // PASSED IN parameter
    // passed in values: challenge Title
    
    // TODO: selection mode on or off
    @State private var isSelectionModeOn: Bool = false
    @State private var selectedIds: Set<String> = []
    
    @State private var selectedExperience: Experience?
    
    // view model info
    private let viewModel: ExperienceListViewModel = ExperienceListViewModel()
    private let restaurantRepository: RestaurantRepository = RestaurantRepository()
    
    var body: some View {
        Group {
            if permissionManager.locationAuthorization == .authorizedWhenInUse ||
                permissionManager.locationAuthorization == .authorizedAlways {
                contentView
            } else {
                ProgressView("Requesting Location Permission...")
                    .onAppear {
                        permissionManager.requestLocationPermission()
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(challenge.title ?? "Untitled Challenge")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
            }
            
            // Select Done toggle (to the end)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isSelectionModeOn ? "Done" : "Select") {
                    isSelectionModeOn.toggle()
                    if !isSelectionModeOn { selectedIds.removeAll() }
                }
            }
            
            // "Select All" shows only in selection mode
            ToolbarItem(placement: .navigationBarLeading) {
                if isSelectionModeOn {
                    Button("Select All") {
                        // Logic to select all items
                        selectedIds = Set(viewModel.experiences.map { $0.id })
                    }
                }
            }
        }
        .toolbarBackground(.appBackground, for: .navigationBar) // set color to toolbar
        .sheet(item: $selectedExperience) { restaurant in
            RestaurantDetailView(
                restaurantId: viewModel.experiences.first(where: { $0.id == restaurant.id })?.restaurant_id ?? ""
            )
                .presentationDetents([.large]) // drawer-style
                .presentationDragIndicator(.visible)
        }
    }
    
    var contentView: some View {
        GeometryReader { geo in
            BackgroundScaffold {
                ScrollView(.vertical, showsIndicators: false) {
                    // 这个spacing是给每个item的间距
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.experiences) { experience in
                            ExperienceListItem(
                                isSelected: Binding(
                                    // returns TRUE if selectedIds contaisn the restaurant id
                                    get: { selectedIds.contains(experience.id) },
                                    // update the selectedIds when the toggle is changed
                                    set: { isSelected in
                                        if isSelected {
                                            selectedIds.insert(experience.id)
                                        } else {
                                            selectedIds.remove(experience.id)
                                        }
                                    }
                                ),
                                isSelectionModeOn: isSelectionModeOn,
                                onTap: {
                                    selectedExperience = experience // set the
                                }
                            )
                            .listRowBackground(Color.clear) // transparent background
                            .listRowSeparator(.hidden)
                        }
                    }
                    .onAppear {
                        Task {
                            // Load restaurants when the view appears
                            do {
                                try await viewModel.fetchExperiences(challengeId: challenge.id)
                            } catch {
                                print("Error fetching experiences: \(error)")
                                throw error
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) // hide list background
                    .listRowSpacing(10) // remove the default padding
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(10) // remove the padding
                }
                .padding(10)
            }
            
            // .toolbarBackground(.visible, for: .navigationBar) // force make the toolbar visible?
        }
    }

    
    func loadExperiencesFromChallenge() {
        // Load restaurants when the view appears
        Task {
            do {
                // Fetch restaurants for the challenge
                try await viewModel.fetchExperiences(challengeId: challenge.id)
            }
        }
    }
}

