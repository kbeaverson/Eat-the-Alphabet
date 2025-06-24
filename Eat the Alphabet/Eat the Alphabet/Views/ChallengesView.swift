//
//  ChallengesView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/8/25.
//

import SwiftUI
import CoreLocation

struct ChallengesView: View {
    @State private var challenges = [ChallengeViewModel]()

    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack(spacing: 20) {
                    Text("Challenges View")
                    // TODO: pass in real title of challenge
                    // NOTE: @Binging valuemust use a reference to a @State or another @Bingding
                    NavigationLink( destination: RestaurantListView(challengeTitle: .constant(challenges[0].challenge.title))) {
                        Text("Sample Challenge")
                            .frame(width: fieldWidth, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.buttonBg)
                            )
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                    }
                }
            }
        }
    }
}

#Preview {
    ChallengesView()
}
