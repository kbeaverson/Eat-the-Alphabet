//
//  Untitled.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/5.
//

import SwiftUI

// TODO: this is macOS checkbox style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .gray)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
