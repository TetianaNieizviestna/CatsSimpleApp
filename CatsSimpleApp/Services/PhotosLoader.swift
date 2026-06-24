//
//  PhotosLoader.swift
//  CatsSimpleApp
//

import Foundation

protocol PhotosLoaderType {
    func loadPhotos(pagination: Pagination, breedId: String?) async throws -> [Photo]
    func loadPhoto(id: String) async throws -> Photo
}

final class PhotosLoader: PhotosLoaderType {
    private let api: CatAPIType

    init(api: CatAPIType) {
        self.api = api
    }

    func loadPhotos(pagination: Pagination, breedId: String?) async throws -> [Photo] {
        try await api.loadPhotos(pagination: pagination, breedId: breedId)
    }

    func loadPhoto(id: String) async throws -> Photo {
        try await api.loadPhoto(id: id)
    }
}
