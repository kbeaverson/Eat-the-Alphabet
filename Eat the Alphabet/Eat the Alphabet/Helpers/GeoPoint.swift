//
//  GeoPoint.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/23.
//

import CoreLocation

struct GeoPoint: Codable {
    let latitude: Double
    let longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
