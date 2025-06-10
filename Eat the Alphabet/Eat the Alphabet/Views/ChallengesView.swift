//
//  ChallengesView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI

struct ChallengesView: View {
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                Text("Challenges View")
            }
        }
    }
}

#Preview {
    ChallengesView()
}
