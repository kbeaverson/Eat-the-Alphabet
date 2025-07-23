//
//  RestaurantListPage.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/11.
//

import SwiftUI
import CoreLocation

struct ChallengeDetailsView: View {
    //    @Environment(\.dismiss) var dismiss // ?
    // @EnvironmentObject var appState: AppState //
    @EnvironmentObject var permissionManager: PermissionManager // Location permission manager
    
    // challenge experience
    let challenge: Challenge // PASSED IN parameter
    // passed in values: challenge Title
    
    @State private var isSelectionModeOn: Bool = false
    @State private var selectedIds: Set<String> = []
    @State private var selectedExperience: Experience?
    
    @State private var cllCoord: CLLocationCoordinate2D? = nil // for location
    
    // view model info
    @StateObject private var viewModel: ExperienceListViewModel = ExperienceListViewModel()
    
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
    }
    
    var contentView: some View {
        GeometryReader { geo in
            BackgroundScaffold {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 10) {
                        // 上半部分：Challenge 信息
                        VStack(alignment: .leading, spacing: 8) {
                            Text(challenge.title ?? "Untitled Challenge")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                            HStack {
                                Text("Created at: \(challenge.created_at.formatted(.dateTime.year().month().day().hour().minute()))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Radius: \(String(format: "%.1f", challenge.radius))km")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let center = challenge.center_wgs {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.caption)
                                    Text("Center: \(String(format: "%.6f", abs(cllCoord?.latitude ?? 0.0)))(\((cllCoord?.latitude ?? 0.0) >= 0 ? "N" : "S")), \(String(format: "%.6f", abs(cllCoord?.longitude ?? 0.0)))(\((cllCoord?.longitude ?? 0.0) >= 0 ? "E" : "W"))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            if let desc = challenge.description {
                                Text(desc)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(15)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.white).opacity(0.5)))
                        
                        // 下半部分：体验列表
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.experiences) { experience in
                                // click will navigate to the ExperienceDetailView
                                ExperienceListItem(
                                    experience: experience,
                                    isSelected: Binding(
                                        get: { selectedIds.contains(experience.id) },
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
                                        selectedExperience = experience
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .onAppear {
                        Task {
                            do {
                                try await viewModel.fetchExperiences(challengeId: challenge.id)
                                let coordinate2D: CLLocationCoordinate2D? = await viewModel.getCLLCoordinates(for: challenge.id)
                                await MainActor.run {
                                    self.cllCoord = coordinate2D
                                }
                            } catch {
                                print("Error fetching experiences: \(error)")
                            }
                        }
                    }
                }
                .padding(10)
            }
            .toolbar {
                if let cllCoord_notNil: CLLocationCoordinate2D = cllCoord {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: ExperienceCreationView(challengeCenter: cllCoord_notNil, challengeId: challenge.id)) {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
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

