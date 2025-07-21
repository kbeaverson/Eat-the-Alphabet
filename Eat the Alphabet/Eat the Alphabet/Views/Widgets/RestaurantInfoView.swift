//
//  RestaurantInfoView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 7/20/25.
//
import SwiftUI
import MapKit

struct RestaurantInfoView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    @State var selectedResult: MKMapItem
    var route: MKRoute?
    
    private var restaurantDetails: (name: String, address: String, phone: String?) {
        let name = selectedResult.name ?? "Unknown Restaurant Name"
        let address = selectedResult.placemark.title ?? "Unknown Address"
        let phone = selectedResult.phoneNumber
        return (name, address, phone)
    }
    
    private var travelTime: String? {
        guard let route else {return nil}
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
                .onAppear {
                    getLookAroundScene()
                }
                .onChange(of: selectedResult) {
                    getLookAroundScene()
                }
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            print("Getting lookaround scene")
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
            print("Lookaround scene acquired")
        }
    }
}
