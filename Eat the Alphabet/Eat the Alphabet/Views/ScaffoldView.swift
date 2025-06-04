//
//  ScaffoldView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/5.
//
import SwiftUI

struct BackgroundScaffold<Content: View>: View {
    let content: () -> Content

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()
            content()
        }
    }
}
