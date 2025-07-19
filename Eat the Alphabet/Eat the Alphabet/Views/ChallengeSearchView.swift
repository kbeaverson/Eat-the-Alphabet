//
//  ChallengeSearchView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import SwiftUI

struct ChallengeSearchView: View {
    @State private var searchText: String = ""
    // @State private var results: [Challenge] = [] // 这里用 String 占位，实际可替换为 Challenge 等模型
    @State private var isSelectionModeOn: Bool = false
    @State private var selectedIds: Set<String> = []
    
    // ChallengeListViewModel
    @StateObject private var viewModel : ChallengeListViewModel = ChallengeListViewModel()

    var body: some View {
        GeometryReader { geo in
            BackgroundScaffold {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        TextField("Only Search by Id is Supported by now", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: geo.size.width * 0.8)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .submitLabel(.search)
                            .onSubmit { performSearch() }
                        Button(action: {
                            performSearch()
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                    
                    if viewModel.challenges.isEmpty {
                        Text("暂无搜索结果\nNo results found")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            
                            ForEach(viewModel.challenges, id: \.id) { item in
                                ChallengeListItem(challenge: item, isSelected: Binding(
                                    get: { selectedIds.contains(item.id) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedIds.insert(item.id)
                                        } else {
                                            selectedIds.remove(item.id)
                                        }
                                    }),
                                    isSelectionModeOn: isSelectionModeOn)
                            }
                            
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }

    private func performSearch() {
        // 这里模拟搜索逻辑，实际可替换为异步网络请求
        // results = searchText.isEmpty ? [] : (1...5).map { "\(searchText) 结果\($0)" }
        // 真实搜索逻辑
        Task {
            do {
                // use repo -> searchChallenges(byIdPart: String) async throws -> [Challenge]
                try await viewModel.searchChallenges(byIdPart: searchText)
            } catch {
                print("Search failed: \(error)")
            }
        }
    }
}
