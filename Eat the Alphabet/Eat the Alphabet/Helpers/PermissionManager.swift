//
//  PermissionManager.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/15.
//

import Foundation
import CoreLocation
import AVFoundation
import UserNotifications

class PermissionManager: NSObject, ObservableObject {
    static let shared = PermissionManager()
    
    private let locationManager = CLLocationManager()
    @Published var locationAuthorization: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocationCoordinate2D?

    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Location
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Notification
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // MARK: - Camera
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
        default:
            completion(false)
        }
    }
}

extension PermissionManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorization = manager.authorizationStatus
        if locationAuthorization == .authorizedWhenInUse || locationAuthorization == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
}
