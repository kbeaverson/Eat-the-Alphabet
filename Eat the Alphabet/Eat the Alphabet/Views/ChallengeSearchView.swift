//
//  ChallengeSearchView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import SwiftUI

struct ChallengeSearchView: View {
    @State private var searchText: String = ""
    @State private var results: [String] = [] // 这里用 String 占位，实际可替换为 Challenge 等模型

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
                    
                    if results.isEmpty {
                        Text("暂无搜索结果\nNo results found")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        List(results, id: \.self) { item in
                            Text(item)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }

    private func performSearch() {
        // 这里模拟搜索逻辑，实际可替换为异步网络请求
        results = searchText.isEmpty ? [] : (1...5).map { "\(searchText) 结果\($0)" }
    }
}
