//
//  MapView.swift
//  Eat the Alphabet
//
//  Created by Kenny Beaverson on 7/9/25.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let columbus = CLLocationCoordinate2D(latitude: 39.961506029178366, longitude: -82.99362548656407)
}

struct MapView: View {
    // @Environment(\.dismiss) private var dismiss
    
    var challengeCenter: CLLocationCoordinate2D
    @Binding var restaurant: Restaurant?
    @State private var position: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width * 0.9
            let infoHeight = geo.size.height * 0.2
            Map(position: $position, selection: $selectedResult) {
                Annotation("Challenge Center", coordinate: challengeCenter) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.secondary, lineWidth: 5)
                        Image(systemName: "star.hexagon")
                            .padding(5)
                    }
                }
                
                UserAnnotation()
                
                ForEach(searchResults, id: \.self) { result in
                    Marker(item: result)
                }
            }
            .mapStyle(.hybrid)
            .overlay(alignment: .topTrailing) {
                
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    VStack(spacing: 0){
                        if let selectedResult {
                            SelectRestaurantButton(selectedRestaurant: selectedResult, restaurant: $restaurant)
                                .padding(.top)
                            RestaurantInfoView(selectedResult: selectedResult, route: route)
                                .frame(height: infoHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top, .horizontal])
                        }
                        SearchButton(searchResults: $searchResults, visibleRegion: visibleRegion)
                            .padding([.top, .leading, .trailing])
                    }
                    Spacer()
                }
                .background(.thinMaterial)
            }
            .onChange(of: searchResults) {
                position = .automatic
            }
            .onChange(of: selectedResult) {
                getDirections()
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
    }
    
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .columbus))
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    @Previewable @State var center: CLLocationCoordinate2D = CLLocationCoordinate2D.columbus
    @Previewable @State var restaurant: Restaurant? = nil /*Restaurant(id: "", name: "", created_at: Date.now, cuisine: "", avg_per_cost: nil, map_imported_id: "", map_imported_rating: nil, rating: nil, address_wgs: nil, address_text: nil, details: nil, image_url: nil)*/
    MapView(challengeCenter: center, restaurant: $restaurant)
}
