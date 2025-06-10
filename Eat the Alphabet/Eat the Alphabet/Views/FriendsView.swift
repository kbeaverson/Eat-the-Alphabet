//
//  FriendsView.swift
//  Eat the Alphabet
//
//  Created by Will Erkman on 6/9/25.
//

import SwiftUI


struct FriendsView: View {
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.6
            BackgroundScaffold {
                Text("Friends View")
            }
        }
    }
}

#Preview {
    FriendsView()
}
