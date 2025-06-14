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
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .background(
                            configuration.isOn ?
                                RoundedRectangle(cornerRadius: 6).fill(Color.blue) :
                                RoundedRectangle(cornerRadius: 6).fill(Color.white)
                        )
                        .frame(width: 24, height: 24)
                    
                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                }
                configuration.label
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
