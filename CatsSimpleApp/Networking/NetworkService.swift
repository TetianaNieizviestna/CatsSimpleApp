//
//  NetworkService.swift
//  CatsSimpleApp
//

import Foundation

protocol CatAPIType {
    func loadBreeds(pagination: Pagination) async throws -> [Breed]
    func loadPhotos(pagination: Pagination, breedId: String?) async throws -> [Photo]
    func loadPhoto(id: String) async throws -> Photo
}

final class CatAPI: CatAPIType {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func loadBreeds(pagination: Pagination) async throws -> [Breed] {
        try await send(
            path: "/breeds",
            query: [
                "limit": "\(pagination.limit)",
                "page": "\(pagination.page)"
            ]
        )
    }

    func loadPhotos(pagination: Pagination, breedId: String?) async throws -> [Photo] {
        var query: [String: String] = [
            "limit": "\(pagination.limit)",
            "page": "\(pagination.page)"
        ]
        if let breedId { query["breed_id"] = breedId }
        return try await send(path: "/images/search", query: query)
    }

    func loadPhoto(id: String) async throws -> Photo {
        try await send(path: "/images/\(id)", query: [:])
    }

    private func send<T: Decodable>(path: String, query: [String: String]) async throws -> T {
        guard var components = URLComponents(
            url: Defines.API.baseUrl.appendingPathComponent(path),
            resolvingAgainstBaseURL: true
        ) else {
            throw APIError.invalidURL
        }
        if !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Defines.API.accessKey, forHTTPHeaderField: "x-api-key")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.nonHTTPResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.serverStatus(http.statusCode)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
