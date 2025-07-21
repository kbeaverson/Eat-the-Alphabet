//
//  ChallengesView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import CoreLocation

// for the ChallengesView, on in 2nd of the root tab navigation
struct ChallengesView: View {
    // ViewModel
    @StateObject private var viewModel : ChallengeListViewModel = ChallengeListViewModel()
        
    @State private var isSelectionModeOn: Bool = false
    @State private var selectedIds: Set<String> = []
    // @State private var showSearch: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(self.viewModel.challenges, id: \.id) { challenge in
                            ChallengeListItem(challenge: challenge,
                                isSelected: Binding(
                                    get: { selectedIds.contains(challenge.id) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedIds.insert(challenge.id)
                                        } else {
                                            selectedIds.remove(challenge.id)
                                        }
                                    }
                                ),
                                isSelectionModeOn: isSelectionModeOn,
                            )
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top) // 关键：顶部对齐
                }
                .frame(maxHeight: .infinity, alignment: .top) // 关键：顶部对齐
                .padding(.horizontal, 10)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    if (isSelectionModeOn) {
                        Button("Cancel") {
                            // reset selected list
                            selectedIds.removeAll()
                            isSelectionModeOn.toggle()
                        }
                    }
                    NavigationLink(destination: ChallengeCreationView()) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button( isSelectionModeOn ? "Select" : "Select All" ) {
                        if (isSelectionModeOn) { selectedIds = Set(viewModel.challenges.map { $0.id }) }
                        else { isSelectionModeOn = true }
                    }
                    
                    // search button with icon
                    NavigationLink(destination: ChallengeSearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .onAppear {
                loadChallenges()
            }
        }
    }
    
    func loadChallenges() {
        Task {
            // Fetch challenges when the view appears
            do {
                try await viewModel.getChallengesByAccount()
            } catch {
                print("Failed to load challenges: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChallengesView()
    }
}
