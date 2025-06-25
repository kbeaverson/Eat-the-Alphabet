//
//  UploadHelper.swift
//  Eat the Alphabet
//
//  Created by Ronald Liao on 2025/6/25.
//

import Foundation
import Supabase
import PhotosUI
import UIKit

final class SupabaseStorageHelper {
    static let shared = SupabaseStorageHelper()
    private let client = SupabaseManager.shared.client

    enum Bucket: String {
        case restaurantImages = "restaurantimages"
        case reviewImages = "reviewimages"
        case experienceImages = "experienceimages"
    }

    /// Uploads image data to the specified bucket and returns the public path
    func uploadImage(image: UIImage, to bucket: Bucket, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(UploadError.invalidImageData))
            return
        }

        Task {
            do {
                let path = "public/\(fileName)"
                try await client.storage
                    .from(bucket.rawValue)
                    .upload(
                        path: path,
                        file: imageData,
                        options: FileOptions(
                            cacheControl: "3600",
                            contentType: "image/png",
                            upsert: false
                        )
                    )
                completion(.success(path))
            } catch {
                completion(.failure(error))
            }
        }
    }

    enum UploadError: Error {
        case invalidImageData
    }
}
