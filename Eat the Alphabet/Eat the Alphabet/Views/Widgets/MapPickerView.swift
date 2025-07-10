//
//  MapPickerView.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/7/8.
//

import SwiftUI
import MapKit

struct MapPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: CLLocationCoordinate2D?
    var libraryLocation = CLLocationCoordinate2D(latitude: 40.001599, longitude: -83.013333)
    @Namespace var mapScope
    
    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width * 0.6
            BackgroundScaffold {
                VStack {
                    MapReader { proxy in
                        Map (scope: mapScope) {
                            Annotation("18th Avenue Library", coordinate: libraryLocation) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.yellow)
                                    Text("📚")
                                        .padding(5)
                                }
                            }
                            // 如果已选点，显示一个红色标注
                            if let picked = selectedLocation {
                                Annotation("Picked", coordinate: picked) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 30, height: 30)
                                        Text("📍")
                                    }
                                }
                            }
                        }
                        .mapControls({
                            MapUserLocationButton()
                        })
                        .mapControlVisibility(.visible)
                        .navigationTitle("Pick Center")
                        .onTapGesture(coordinateSpace: .local) { point in
                            // 把屏幕点（CGPoint）转换成经纬度
                            if let coord = proxy.convert(point, from: .local) {
                                selectedLocation = coord
                            }
                        }
                        .frame(height: geo.size.height * 0.8)
                    }
                    MapUserLocationButton(scope: mapScope)
                    Button(action: {
                        dismiss()
                    }) {
                        Text((selectedLocation != nil) ? "Confirm Location" : "Back")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .frame(maxWidth: buttonWidth)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .toolbarBackground(.appBackground)
        }
    }
}
