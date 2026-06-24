//
//  BreedsLoader.swift
//  CatsSimpleApp
//

import Foundation

protocol BreedsLoaderType {
    func loadBreeds(pagination: Pagination) async throws -> [Breed]
}

final class BreedsLoader: BreedsLoaderType {
    private let api: CatAPIType

    init(api: CatAPIType) {
        self.api = api
    }

    func loadBreeds(pagination: Pagination) async throws -> [Breed] {
        try await api.loadBreeds(pagination: pagination)
    }
}
