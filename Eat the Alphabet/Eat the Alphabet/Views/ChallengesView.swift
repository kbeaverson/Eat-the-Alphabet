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
                VStack(spacing: 20) {
                    Text("Challenges View")
                    
                    NavigationLink( destination: RestaurantListView()) {
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
